require "formula"

class Tkgate < Formula
  homepage ""
  url "http://www.tkgate.org/downloads/tkgate-2.0-b10.tgz"
  sha1 "085f2e6a5d49e1b382b16ec60d7cdbad266dea19"

  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    ENV.append 'CPPFLAGS', "-DUSE_INTERP_RESULT"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tkgate"
  end
end
