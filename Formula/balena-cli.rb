class BalenaCli < Formula
  url "https://github.com/balena-io/balena-cli/releases/download/v12.37.1/balena-cli-v12.37.1-macOS-x64-standalone.zip"
  version "12.37.1"
  sha256 "3365114846be8886f7cf4f922224a162e137c0e63787ff59873221b27bab0bdd"

  def install
    share.install Dir['*']
    bin.mkdir
    ln_sf (share/"balena").to_s, (bin/"balena").to_s
  end
end
