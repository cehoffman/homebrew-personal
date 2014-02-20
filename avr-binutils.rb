require 'formula'

class AvrBinutils < Formula
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.bz2'
  mirror 'http://ftp.gnu.org/gun/binutils/binutils-2.24.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  # sha1 '587fca86f6c85949576f4536a90a3c76ffc1a3e1'

  option 'disable-libbfd', 'Disable installation of libbfd.'

  def install
    ENV['CPPFLAGS'] = "-I#{include}"
    p ENV['CPPFLAGS']

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
    end unless build.include? 'disable-libbfd'

    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'
    ENV.delete 'CC'
    ENV.delete 'CXX'

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
