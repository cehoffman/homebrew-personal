require 'formula'

class AvrLibc < Formula
  homepage 'http://www.nongnu.org/avr-libc/'
  url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.0.tar.bz2'
  sha1 '2e3815221be8e22f5f2c07b922ce92ecfa85bade'

  depends_on 'avr-gcc'

  resource 'avr-libc-manpages' do
    url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-manpages-1.8.0.tar.bz2'
    sha1 '586cf60bb9d2b67498b73b38b546f7b4620dc86c'
  end

  resource 'avr-libc-html' do
    url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-user-manual-1.8.0.tar.bz2'
    sha1 '54f991e63c46eb430986bea3bae0e28cbe0b87c8'
  end

  def install
    ENV['CC'] = Formula.factory('avr-gcc').opt_prefix/'bin/avr-gcc'
    system "./configure",
      "--build=#{%x[./config.guess].strip}",
      "--prefix=#{prefix}",
      "--host=avr"
    system 'make', 'install'

    man.install resource('avr-libc-manpages')
    (share/'doc/avr-libc').install resource('avr-libc-html')
  end
end
