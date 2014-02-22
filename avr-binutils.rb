require 'formula'

class AvrBinutils < Formula
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.bz2'
  mirror 'http://ftp.gnu.org/gun/binutils/binutils-2.24.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  sha1 '7ac75404ddb3c4910c7594b51ddfc76d4693debb'

  option 'without-libbfd', 'Disable installation of libbfd.'

  def install
    args = [
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}",
      '--disable-werror',
      '--disable-nls',
      '--with-dwarf2',
    ]

    cd 'bfd' do
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
    {
      :p0 => ['https://gist.github.com/larsimmisch/4190960/raw/b36f3d6d086980006f097ae0acc80b3ada7bb7b1/avr-binutils-size.patch'],
      :p1 => [
              # 'https://gist.githubusercontent.com/cehoffman/9110871/raw/dd29a43ec96dfb43d128afa2c53a9b00902cfd94/binutils-avr-coff.patch',
              'https://gist.githubusercontent.com/cehoffman/9110871/raw/dd0bda58fa1bc21b5604a0b9399b647b6c50d261/binutils-as-dwarf.patch',
              'https://gist.githubusercontent.com/cehoffman/9110871/raw/7e51e3daf97c5e3bbe4ab7138808ea16672aed69/binutils-dwarf2-AVRStudio-workaround.patch',
      ],
    }
  end

end
