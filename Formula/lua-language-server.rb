class LuaLanguageServer < Formula
  desc "LSP for Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git"
  version "HEAD"

  depends_on "ninja" => :build

  def install
    cd '3rd/luamake' do
      system 'ninja', '-f', 'ninja/macos.ninja'
    end
    system './3rd/luamake/luamake', 'rebuild'
    bin.install Dir['bin/macOS/*']
    libexec.install 'main.lua', 'platform.lua', 'script', 'locale', 'debugger.lua', 'meta'
  end
end
