require 'formula'

class Mediainfo <Formula
  url 'http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.55_GNU_FromSource.tar.bz2'
  homepage 'http://mediainfo.sourceforge.net'
  md5 'ce02b3074e545f20c4a2c5c900b083a3'

  def install
    system "./CLI_Compile.sh", "--prefix=#{prefix}"
    system "cd MediaInfo/Project/GNU/CLI && make install"
  end
end
