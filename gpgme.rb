require 'formula'

class Gpgme < Formula
  homepage 'http://www.gnupg.org/related_software/gpgme/'
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.4.3.tar.bz2'
  sha1 'ffdb5e4ce85220501515af8ead86fd499525ef9a'

  option 'with-gnupg2', 'Build against gnupg2 instead of gnupg'
  option 'enable-gpgsm', 'Enable gpgsm support'

  depends_on build.with?('gnupg2') ? 'gnupg2' : 'gnupg'
  depends_on 'libgpg-error'
  depends_on 'libassuan'
  depends_on 'pth'

  fails_with :llvm do
    build 2334
  end

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-static"]
    args << '--disable-gpgsm' unless build.include?('enable-gpgsm')
    system "./configure", *args
    system "make"
    system "make check"
    system "make install"
  end
end
