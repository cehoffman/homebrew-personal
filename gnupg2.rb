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
