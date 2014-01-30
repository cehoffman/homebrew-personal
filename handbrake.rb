require 'formula'

class Handbrake <Formula
  head 'svn://svn.handbrake.fr/HandBrake/trunk'
  homepage 'http://handbrake.fr/'

  depends_on 'yasm'
  depends_on 'libtool'
  depends_on 'autoconf'
  depends_on 'automake'

  def install
    system './configure',
            '--launch',
            "--prefix=#{prefix}",
            '--optimize=speed'

    bin.install 'build/xroot/HandBrakeCLI'
    prefix.install 'build/xroot/HandBrake.app'
  end
end


# The HandBrake configure tools look for information from the svn meta info which
# isn't copied over in the default SubversionDownloadStrategy
class SubversionDownloadStrategy
  def stage
    FileUtils.cp_r @co.to_s+"/.", Dir.pwd
  end
end
