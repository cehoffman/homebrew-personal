require 'formula'

class AvrBinutils < Formula
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.bz2'
  mirror 'http://ftp.gnu.org/gun/binutils/binutils-2.24.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  sha1 '7ac75404ddb3c4910c7594b51ddfc76d4693debb'

  option 'without-libbfd', 'Disable installation of libbfd.'

  def install
    ENV['CPPFLAGS'] = "-I#{include}"

    args = ["--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            '--disable-werror',
            '--disable-nls']

    Dir.chdir 'bfd' do
      ohai 'building libbfd'
      system './configure', '--enable-install-libbfd', *args
      system 'make'
      system 'make', 'install'
    end unless build.without? 'libbfd'

    system './configure', '--target=avr', *args

    system 'make'
    system 'make', 'install'
  end

  def patches
    # Support for -C in avr-size. See issue 
    # https://github.com/larsimmisch/homebrew-avr/issues/9
    { :p0 => 'https://gist.github.com/larsimmisch/4190960/raw/b36f3d6d086980006f097ae0acc80b3ada7bb7b1/avr-binutils-size.patch' }
  end

end
