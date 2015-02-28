let pkgs = import <nixpkgs> {}; in
with pkgs;
let myandroidndk = callPackage ./android/androidndk.nix { platformTools = androidenv.platformTools; };    
    android_support_extra = stdenv.mkDerivation {
      buildInputs = [ unzip ];
      buildCommand = ''
        mkdir -p $out
        cd $out
        unzip $src
      '';
      name = "android_support_extra";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/support_r20.zip;
        sha1 = "719c260dc3eb950712988f987daaf91afa9e36af";
      };
      meta = {
        description = "Android v4 support library";
        url = http://developer.android.com/;
      };
    };
    myandroidsdk = callPackage ./android/androidsdk.nix { 
      inherit (pkgs) stdenv fetchurl unzip makeWrapper;
      inherit (pkgs) freetype fontconfig glib gtk atk mesa file alsaLib jdk;
      inherit (pkgs.xorg) libX11 libXext libXrender libxcb libXau libXdmcp libXtst;

      inherit (androidenv) platformTools buildTools support supportRepository platforms sysimages addons;
      inherit android_support_extra;

      stdenv_32bit = pkgsi686Linux.stdenv;
      zlib_32bit = pkgsi686Linux.zlib;
      libX11_32bit = pkgsi686Linux.xorg.libX11;
      libxcb_32bit = pkgsi686Linux.xorg.libxcb;
      libXau_32bit = pkgsi686Linux.xorg.libXau;
      libXdmcp_32bit = pkgsi686Linux.xorg.libXdmcp;
      libXext_32bit = pkgsi686Linux.xorg.libXext;
      mesa_32bit = pkgsi686Linux.mesa;
      alsaLib_32bit = pkgsi686Linux.alsaLib;
    };
    myandroidsdk_5_0_1 = myandroidsdk {
      platformVersions = [ "21" ];
      abiVersions = [ "armeabi-v7a" "x86" ];
      useGoogleAPIs = true;
      useExtraSupportLibs = true;
    };
 in
(import <nixpkgs/pkgs/misc/my-env> {
        inherit substituteAll pkgs;
        inherit (stdenv_32bit) mkDerivation;
}) {

          name = "fennecEnv";
          buildInputs = [ # stdenv
                          # pkgconfig gtk 
                          glib # gobjectIntrospection
                          dbus_libs dbus_glib alsaLib 
                          gcc # xlibs.libXrender
                          xlibs.libX11 xlibs.libXext xlibs.libXft xlibs.libXt
                          ats pango freetype fontconfig gdk_pixbuf cairo
                          python
                          autoconf213 unzip zip yasm alsaLib dbus_libs
                          which # atk
                          gstreamer gst_plugins_base pulseaudio 
                          mercurial
                          python27Packages.sqlite3
                          # <don'texist>
                          # stdenv_32bit
                          # pkgs_i686.zlib
                          # zlib_32bit
                          # libX11_32bit 
                          # libxcb_32bit 
                          # libXau_32bit 
                          # libXdmcp_32bit 
                          # libXext_32bit 
                          # mesa_32bit 
                          # alsaLib_32bit
                          # </don'texist>
                          zlib
                          xlibs.libxcb 
                          xlibs.libXau 
                          xlibs.libXdmcp 
                          mesa 
                          # gcc48_multi
                          ncurses
                          jdk ant # androidndk
                          myandroidndk
                          myandroidsdk_5_0_1 
                        ];
       
          extraCmds = ''
           # export LIBPATHS=${dbus_libs}/include/dbus-1.0/dbus:${dbus_libs}/lib/dbus-1.0/include/dbus:${stdenv_32bit.glibc}/lib:${alsaLib}/lib:${xlibs.libX11}/lib:${xlibs.libXext}/lib:${xlibs.libXft}/lib:${xlibs.libXt}/lib:${ats}/lib:${pango}/lib:${freetype}/lib:${cairo}/lib:${zlib}/lib:${xlibs.libxcb}/lib:${xlibs.libXau}/lib:${xlibs.libXdmcp}/lib:${mesa}/lib

           # export C_INCLUDE_PATH=${dbus_libs}/include/dbus-1.0/dbus:${dbus_libs}/lib/dbus-1.0/include/dbus:${stdenv_32bit.glibc}/lib:${alsaLib}/lib:${xlibs.libX11}/lib:${xlibs.libXext}/lib:${xlibs.libXft}/lib:${xlibs.libXt}/lib:${ats}/lib:${pango}/lib:${freetype}/lib:${cairo}/lib:${zlib}/lib:${xlibs.libxcb}/lib:${xlibs.libXau}/lib:${xlibs.libXdmcp}/lib:${mesa}/lib
           # export CPLUS_INCLUDE_PATH=${dbus_libs}/include/dbus-1.0/dbus:${dbus_libs}/lib/dbus-1.0/include/dbus:${stdenv_32bit.glibc}/lib:${alsaLib}/lib:${xlibs.libX11}/lib:${xlibs.libXext}/lib:${xlibs.libXft}/lib:${xlibs.libXt}/lib:${ats}/lib:${pango}/lib:${freetype}/lib:${cairo}/lib:${zlib}/lib:${xlibs.libxcb}/lib:${xlibs.libXau}/lib:${xlibs.libXdmcp}/lib:${mesa}/lib
           # export LIBRARY_PATH=${dbus_libs}/include/dbus-1.0/dbus:${dbus_libs}/lib/dbus-1.0/include/dbus:${stdenv_32bit.glibc}/lib:${alsaLib}/lib:${xlibs.libX11}/lib:${xlibs.libXext}/lib:${xlibs.libXft}/lib:${xlibs.libXt}/lib:${ats}/lib:${pango}/lib:${freetype}/lib:${cairo}/lib:$LIBRARY_PATH:${zlib}/lib:${xlibs.libxcb}/lib:${xlibs.libXau}/lib:${xlibs.libXdmcp}/lib:${mesa}/lib
           # LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${dbus_libs}/include/dbus-1.0/dbus:${dbus_libs}/lib/dbus-1.0/include/dbus:${stdenv_32bit.glibc}/lib:${alsaLib}/lib:${xlibs.libX11}/lib:${xlibs.libXext}/lib:${xlibs.libXft}/lib:${xlibs.libXt}/lib:${ats}/lib:${pango}/lib:${freetype}/lib:${cairo}/lib:${zlib}/lib:${xlibs.libxcb}/lib:${xlibs.libXau}/lib:${xlibs.libXdmcp}/lib:${mesa}/lib


           # # for i in $nativeBuildInputs; do
           # #   LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$i/lib
           # # done
           # export LD_LIBRARY_PATH
           # export AUTOCONF=autoconf
          '';
        }
