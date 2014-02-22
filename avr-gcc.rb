require 'formula'

# print avr-gcc's builtin include paths
# `avr-gcc -print-prog-name=cc1plus` -v

class AvrGcc < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2'
  sha1 '810fb70bd721e1d9f446b6503afe0a9088b62986'

  depends_on 'avr-binutils'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  option 'without-cxx', 'build without support for C++'

  resource 'avr-libc' do
    url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.0.tar.bz2'
    sha1 '2e3815221be8e22f5f2c07b922ce92ecfa85bade'
  end

  resource 'avr-libc-manpages' do
    url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-manpages-1.8.0.tar.bz2'
    sha1 '586cf60bb9d2b67498b73b38b546f7b4620dc86c'
  end

  resource 'avr-libc-html' do
    url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-user-manual-1.8.0.tar.bz2'
    sha1 '54f991e63c46eb430986bea3bae0e28cbe0b87c8'
  end

  def install
    binutils = Formula.factory('avr-binutils')
    args = [
            "--target=avr",
            '--enable-long-long',
            '--disable-checking',
            '--disable-shared',
            "--disable-libssp",
            "--disable-nls",
            "--with-dwarf2",
            # Sandbox everything...
            "--prefix=#{prefix}",
            "--with-gmp=#{Formula.factory('gmp').opt_prefix}",
            "--with-mpfr=#{Formula.factory('mpfr').opt_prefix}",
            "--with-mpc=#{Formula.factory('libmpc').opt_prefix}",
            # This shouldn't be necessary
            "--with-as=#{binutils.opt_prefix}/bin/avr-as",
            "--with-ld=#{binutils.opt_prefix}/bin/avr-ld"
           ]

    # The C compiler is always built, C++ can be disabled
    languages = %w[c]
    languages << 'c++' unless build.without? 'cxx'

    mkdir 'build' do
      system '../configure', "--enable-languages=#{languages.join(',')}", *args
      system 'make'

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.

      system 'make', 'install'
    end

    resource('avr-libc').stage do
      ENV['CC'] = bin/'avr-gcc'
      ENV['CXX'] = bin/'avr-g++'
      system "./configure",
        "--build=#{%x[./config.guess].strip}",
        "--prefix=#{prefix}",
        "--host=avr"
      system 'make', 'install'
    end

    man.install resource('avr-libc-manpages')
    (share/'doc/avr-libc').install resource('avr-libc-html')
  end

  def caveats; <<-EOS.undent
    Include the following directory in your path to use avr-gcc easily.
      #{opt_prefix}/bin
    EOS
  end
end
