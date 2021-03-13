class BalenaCli < Formula
  url "https://github.com/balena-io/balena-cli/releases/download/v12.38.1/balena-cli-v12.38.1-macOS-x64-standalone.zip"
  version "12.38.1"
  sha256 "04427aa8e55814487e8a257623a72dd7064c1129a8cff14b6de8d27ba6228917"

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"balena"
  end
end
