require 'formula'

class Doctorjs < Formula
  head 'https://github.com/mozilla/doctorjs.git', :using => :git
  homepage 'https://github.com/mozilla/doctorjs'

  depends_on 'node'

  def install
    inreplace 'Makefile', /PREFIX=.*/, "PREFIX=#{prefix}"
    system 'make', 'install'
  end
end
