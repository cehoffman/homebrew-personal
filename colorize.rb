require 'formula'

class Colorize < Formula
  url 'https://raw.github.com/gist/1129908/db0ff566e7099cfd2e6cba58cb7036a36068b6df/colorize.c'
  homepage 'http://www.zsh.org/mla/users/2004/msg00804.html'
  sha1 '95f8052b19945de6150c74c8954af63e277af172'
  version '1.0.0'


  def install
    bin.mkpath
    system 'gcc', '-o', "#{bin}/colorize", 'colorize.c'
  end
end
