require 'formula'

class Stderred < Formula
  homepage 'https://github.com/sickill/stderred'
  url 'https://github.com/sickill/stderred.git'
  version 'HEAD'

  depends_on 'cmake'

  def install
    ENV.universal_binary if OS.mac?
    mkdir 'build' do
      system 'cmake', "-DCMAKE_INSTALL_PREFIX=#{prefix}", '../src'
      system 'make', 'install'
    end
  end

  def caveats; <<-EOS.undent
      To use stderred export the following before running a command
          export DYLD_INSERT_LIBRARIES="#{HOMEBREW_PREFIX}/lib/libstderred.dylib${DYLD_INSERT_LIBRARIES:+:DYLD_INSERT_LIBRARIES}"
    EOS
  end
end
