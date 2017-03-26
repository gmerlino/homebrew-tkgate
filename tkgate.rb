require "formula"

class Tkgate < Formula
  homepage ""
  url "http://pkgs.fedoraproject.org/repo/pkgs/tkgate/tkgate-2.0-b10.tgz/84ffe959868d39ec856b5ff1c70136c3/tkgate-2.0-b10.tgz"
  sha256 "4ef6a9c5b71325cec0d53d55dfd386a344dc7f139c49e9a145ad4ace7a302057"

  depends_on :x11

  patch :DATA

  def install
    ENV.append 'CPPFLAGS', "-DUSE_INTERP_RESULT"
    system "./configure",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tkgate"
  end
end

__END__
diff --git a/configure b/configure
index d0a164f..e995950 100755
--- a/configure
+++ b/configure
@@ -22091,7 +22091,7 @@ echo $ECHO_N "checking for iconv.h... $ECHO_C" >&6; }
     fi
   done
   for p in $TKGATE_LIBDIRS; do
-    if test -f $p/libiconv.a; then
+    if test -f $p/libiconv.dylib; then
       iconv_lib_dir=$p
     fi
   done
@@ -24445,7 +24445,7 @@ _ACEOF
 
 
    L=""
-   for v in $TCL_LPATH $TCL_LPATH $ICONV_LPATH; do
+   for v in $TCL_LPATH $TK_LPATH $ICONV_LPATH; do
      add_ok=1
      for q in $L; do
 	if test X$q = X$v; then
@@ -24464,10 +24464,14 @@ _ACEOF
    for v in $TCL_LIB $TK_LIB $X_PRE_LIBS -lX11 $X_EXTRA_LIBS $ICONV_LIB; do
      add_ok=1
      for q in $L; do
-	if test X$q = X$v; then
-	  add_ok=0
-	  break
-        fi
+       if test X$q != X"-F/System/Library/Frameworks"; then
+         if test X$q != X"-framework"; then
+           if test X$q = X$v; then
+             add_ok=0
+             break
+           fi
+         fi
+       fi
      done
      if test "$add_ok" = "1"; then
        L="$L $v"
