require "formula"

class Tkgate < Formula
  homepage "https://bitbucket.org/starling13/tkgate"
  head "https://bitbucket.org/starling13/tkgate", :using => :hg

  depends_on "cairo" => "with-x11"
  depends_on "pango" => "with-x11"
  depends_on "gmerlino/tcl-tk/tcl-tk" => "with-x11"

  patch :DATA

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["tcl-tk"].opt_lib}/pkgconfig"
    ENV.append 'TCL_IPATH', "-I#{Formula["tcl-tk"].opt_include}"
    ENV.append 'TCL_LPATH', "-L#{Formula["tcl-tk"].opt_lib}"
    ENV.append 'CPPFLAGS', "-g"
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
--- a/configure
+++ b/configure
@@ -2911,12 +2911,12 @@
 #
 # Directories to search for include files
 #
-TKGATE_INCDIRS="/usr/X11R6/include /usr/X11/include /pkgs/include /usr/local/include /usr/openwin/include /usr/X/include /usr/include /sw/include /opt/local/include"
+TKGATE_INCDIRS="/usr/local/opt/tcl-tk/include /usr/X11R6/include /usr/X11/include /pkgs/include /usr/local/include /usr/openwin/include /usr/X/include /usr/include /sw/include /opt/local/include"

 #
 # Directories to search for library files
 #
-TKGATE_LIBDIRS="/usr/X11R6/lib /usr/X11/lib /pkgs/lib /usr/local/lib /usr/lib /sw/lib /opt/local/lib /usr/local/lib/tcl /usr/lib64"
+TKGATE_LIBDIRS="/usr/local/opt/tcl-tk/lib /usr/X11R6/lib /usr/X11/lib /pkgs/lib /usr/local/lib /usr/lib /sw/lib /opt/local/lib /usr/local/lib/tcl /usr/lib64"

 #
 # Libraries we may need if available.
@@ -6024,7 +6024,7 @@ $as_echo_n "checking for iconv.h... " >&6; }
     fi
   done
   for p in $TKGATE_LIBDIRS; do
-    if test -f $p/libiconv.a; then
+    if test -f $p/libiconv.dylib; then
       iconv_lib_dir=$p
     fi
   done
@@ -6817,11 +6817,11 @@
	  TCLTK_VERSION=$TCL_VERSION

   TCL_LIB=$TCL_LIB_SPEC
-  TCL_LPATH=""
-  TCL_IPATH=$TCL_INCLUDE_SPEC
+  #TCL_LPATH=""
+  #TCL_IPATH=$TCL_INCLUDE_SPEC
   TK_LIB=$TK_LIB_SPEC
-  TK_LPATH=""
-  TK_IPATH=$TK_INCLUDE_SPEC
+  #TK_LPATH=""
+  #TK_IPATH=$TK_INCLUDE_SPEC

   if test "X$TCL_IPATH" = "X"; then

@@ -7294,10 +7294,14 @@ $as_echo "#define TKGATE_WORDSIZE 64" >>confdefs.h
    for v in $TCL_IPATH $TK_IPATH $X_CFLAGS $ICONV_IPATH; do
      add_ok=1
      for q in $L; do
-	if test X$q = X$v; then
-	  add_ok=0
-	  break
-        fi
+#       if test X$q != X"-F/System/Library/Frameworks"; then
+#         if test X$q != X"-framework"; then
+           if test X$q = X$v; then
+             add_ok=0
+             break
+           fi
+#         fi
+#       fi
      done
      if test "$add_ok" = "1"; then
        L="$L $v"
@@ -7307,7 +7311,7 @@ $as_echo "#define TKGATE_WORDSIZE 64" >>confdefs.h
 
 
    L=""
-   for v in $TCL_LPATH $TCL_LPATH $ICONV_LPATH; do
+   for v in $TCL_LPATH $TK_LPATH $ICONV_LPATH; do
      add_ok=1
      for q in $L; do
 	if test X$q = X$v; then
@@ -7326,10 +7330,14 @@ $as_echo "#define TKGATE_WORDSIZE 64" >>confdefs.h
    for v in $TCL_LIB $TK_LIB $X_PRE_LIBS -lX11 $X_EXTRA_LIBS $ICONV_LIB; do
      add_ok=1
      for q in $L; do
-	if test X$q = X$v; then
-	  add_ok=0
-	  break
-        fi
+#       if test X$q != X"-F/System/Library/Frameworks"; then
+#         if test X$q != X"-framework"; then
+           if test X$q = X$v; then
+             add_ok=0
+             break
+           fi
+#         fi
+#       fi
      done
      if test "$add_ok" = "1"; then
        L="$L $v"
diff --git a/src/common/list.c b/src/common/list.c
--- a/src/common/list.c
+++ b/src/common/list.c
@@ -16,7 +16,6 @@
     51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ****************************************************************************/
 #include <stdlib.h>
-#include <malloc.h>
 #include "misc.h"
 #include "list.h"

diff --git a/src/common/misc.h b/src/common/misc.h
--- a/src/common/misc.h
+++ b/src/common/misc.h
@@ -34,9 +34,6 @@
 #if !HAVE_STRNCASECMP
 int strncasecmp(const char *s1,const char *s2,size_t n);
 #endif
-#if !HAVE_STRCASESTR
-const char *strcasestr(const char *big,const char *little);
-#endif
 #if !HAVE_STRSPN
 size_t strspn(const char *s,const char *charset);
 #endif
