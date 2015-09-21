require "formula"

class Gnupg2 < Formula
  homepage "https://www.gnupg.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.8.tar.bz2"
  sha1 "61f5bc656dd7fddd4ab67b720d47ef0651bfb727"

  option "8192", "Build with support for private keys of up to 8192 bits"

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "npth"
  depends_on "pinentry-mac"
  depends_on "readline" => :optional

  patch :DATA

  def install
    # Adjust package name to fit our scheme of packaging both gnupg 1.x and
    # 2.x, and gpg-agent separately, and adjust tests to fit this scheme
    inreplace "configure" do |s|
      s.gsub! "PACKAGE_NAME='gnupg'", "PACKAGE_NAME='gnupg2'"
      s.gsub! "PACKAGE_TARNAME='gnupg'", "PACKAGE_TARNAME='gnupg2'"
    end
    inreplace "g10/keygen.c", "max=4096", "max=8192" if build.include? "8192"

    p 
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sbindir=#{bin}
      --enable-symcryptrun
      --with-pinentry-pgm=#{Formula['pinentry-mac'].opt_bin}/pinentry-mac
    ]

    if build.with? "readline"
      args << "--with-readline=#{Formula["readline"].opt_prefix}"
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Conflicts with a manpage from the 1.x formula, and
    # gpg-zip isn't installed by this formula anyway
    rm man1/"gpg-zip.1"
  end
end

__END__
Copy and paste of fix from https://github.com/GPGTools/MacGPG2/commit/f4c3e1bbf1c96cf03ad33a364ec10365f68bf63f
to account for removal of pcsc-wrapper and relocation of code.
diff --git a/scd/apdu.c b/scd/apdu.c
index e8797cd..ea47bfb 100644
--- a/scd/apdu.c
+++ b/scd/apdu.c
@@ -29,6 +29,7 @@
 #include <string.h>
 #include <assert.h>
 #include <signal.h>
+#include <pthread.h>
 #ifdef USE_NPTH
 # include <unistd.h>
 # include <fcntl.h>
@@ -944,6 +945,24 @@ dump_pcsc_reader_status (int slot)


 #ifndef NEED_PCSC_WRAPPER
+
+struct myArgs {
+    long pcsc_context;
+    struct pcsc_readerstate_s *rdrstates;
+    pthread_cond_t cond;
+    long err;
+};
+
+// Helper Thread to have a timeout for pcsc_get_status_change.
+void *get_status_change_thread (void *pointer) {
+    struct myArgs *args = pointer;
+    args->err = pcsc_get_status_change (args->pcsc_context,
+                                  0,
+                                  args->rdrstates, 1);
+    pthread_cond_signal(&args->cond);
+    return NULL;
+}
+
 static int
 pcsc_get_status_direct (int slot, unsigned int *status)
 {
@@ -953,9 +972,32 @@ pcsc_get_status_direct (int slot, unsigned int *status)
   memset (rdrstates, 0, sizeof *rdrstates);
   rdrstates[0].reader = reader_table[slot].rdrname;
   rdrstates[0].current_state = PCSC_STATE_UNAWARE;
-  err = pcsc_get_status_change (reader_table[slot].pcsc.context,
-                                0,
-                                rdrstates, 1);
+
+  pthread_t thread;
+  struct myArgs args;
+  args.rdrstates = rdrstates;
+  args.pcsc_context = reader_table[slot].pcsc.context;
+
+  pthread_cond_init(&args.cond, NULL);
+  pthread_create(&thread, NULL, get_status_change_thread, &args);
+
+  static struct timespec time_to_wait = {0, 0};
+  time_to_wait.tv_sec = time(NULL) + 5;
+
+  pthread_mutex_t lock;
+  pthread_mutex_init(&lock, NULL);
+  pthread_mutex_lock(&lock);
+  err = pthread_cond_timedwait(&args.cond, &lock, &time_to_wait);
+  pthread_mutex_unlock(&lock);
+
+  if (err) {
+    pthread_cancel(thread);
+    err = PCSC_E_TIMEOUT;
+  } else {
+    pthread_join (thread, NULL);
+    err = args.err;
+  }
+
   if (err == PCSC_E_TIMEOUT)
     err = 0; /* Timeout is no error error here. */
   if (err)
