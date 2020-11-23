class BalenaCli < Formula
  url "https://github.com/balena-io/balena-cli/releases/download/v12.28.2/balena-cli-v12.28.2-macOS-x64-standalone.zip"
  version "12.28.2"
  sha256 "1b385646bb7366a3e325fccf43e74c03a88cf5892db6fc25948e047a9e6530c4"

  def install
    share.install Dir['*']
    bin.mkdir
    ln_sf (share/"balena").to_s, (bin/"balena").to_s
  end
end
