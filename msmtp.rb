require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.31/msmtp-1.4.31.tar.bz2'
  sha1 'c0edce1e1951968853f15209c8509699ff9e9ab5'

  option 'with-macosx-keyring', "Support Mac OS X Keyring"
  depends_on 'pkg-config' => :build
  depends_on 'curl-ca-bundle' => :optional

  # msmtp enables OS X Keychain support by default, so no need to ask for it.

  def install
    # Msmtp will build against gnutls by default if it exists on the
    # system.  This sets up problems if the user later removes gnutls.
    # So explicitly ask for openssl, and ye shall receive it whether
    # or not gnutls is present.
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-ssl=openssl
    ]
    args << "--with-macosx-keyring" if build.include? 'with-macosx-keyring'

    # The script assumes normal linux ping options, which match for all
    # but the timeout option
    inreplace 'scripts/msmtpq/msmtpq', '-w4 debian.org', '-t4 google.com'
    inreplace 'scripts/msmtpq/msmtpq', 'LOG=~/log/msmtp.queue.log', 'LOG=~/Library/Logs/msmtp.queue.log'

    system "./configure", *args
    system "make", "install"
    bin.install 'scripts/msmtpq/msmtpq', 'scripts/msmtpq/msmtp-queue'
  end
end
