require 'formula'

class PinentryMac < Formula
  url 'https://github.com/GPGTools/pinentry-mac.git', tag: 'v0.9.4'

  def install
    system 'make'

    prefix.install 'build/Release/pinentry-mac.app'
  end
end
