require 'formula'

# print avr-gcc's builtin include paths
# `avr-gcc -print-prog-name=cc1plus` -v

class AvrGcc < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftp.gnu.org/gnu/gcc/gcc-5.2.0/gcc-5.2.0.tar.bz2'
  sha256 '5f835b04b5f7dd4f4d2dc96190ec1621b8d89f2dc6f638f9f8bc1b1014ba8cad'

  depends_on 'avr-binutils'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  option 'without-cxx', 'build without support for C++'

  resource 'avr-libc' do
    url '
    http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.1.tar.bz2'
    sha256 'e6a46c279e023a11e6dff00e6d0dd248f5cb145f5aecddfec53f0ab0cd691965'
  end

  resource 'avr-libc-manpages' do
    url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-manpages-1.8.1.tar.bz2'
    sha256 '93ee7ac6880048abd968873fa3f180a49ec7b141b39c1940b7c4afd6efc9ba6c'
  end

  resource 'avr-libc-html' do
    url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-user-manual-1.8.1.tar.bz2'
    sha256 '0966df5d624f6a24de86086d388914501904302bb60a0cfb0b17d024f2ba7ce9'
  end

  def install
    binutils = Formula['avr-binutils']
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
            "--with-gmp=#{Formula['gmp'].opt_prefix}",
            "--with-mpfr=#{Formula['mpfr'].opt_prefix}",
            "--with-mpc=#{Formula['libmpc'].opt_prefix}",
            # This shouldn't be necessary
            "--with-as=#{binutils.opt_bin}/avr-as",
            "--with-ld=#{binutils.opt_bin}/avr-ld"
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
      #{opt_bin}
    EOS
  end
end
