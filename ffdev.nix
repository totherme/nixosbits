with import <nixpkgs> {};
myEnvFun {
      name = "firefoxEnv";
      buildInputs = [ stdenv pkgconfig gtk glib gobjectIntrospection
                      dbus_libs dbus_glib alsaLib gcc xlibs.libXrender
                      xlibs.libX11 xlibs.libXext xlibs.libXft xlibs.libXt
                      ats pango freetype fontconfig gdk_pixbuf cairo python
                      git autoconf213 unzip zip yasm alsaLib dbus_libs which atk
                      gstreamer gst_plugins_base pulseaudio mercurial 
                      python27Packages.sqlite3
                    ];
    
      extraCmds = ''
       export C_INCLUDE_PATH=${dbus_libs}/include/dbus-1.0:${dbus_libs}/lib/dbus-1.0/include
       export CPLUS_INCLUDE_PATH=${dbus_libs}/include/dbus-1.0:${dbus_libs}/lib/dbus-1.0/include
       LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${stdenv_32bit.cc}/lib64
       # I currently think this loop does nothing...
       for i in $nativeBuildInputs; do
         LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$i/lib
       done
       export LD_LIBRARY_PATH
       export AUTOCONF=autoconf
      '';
    } 
