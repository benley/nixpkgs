{ stdenv, fetchFromGitHub, autoreconfHook, parallel, sassc, inkscape, libxml2, glib, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.89.2.50";

  meta = with stdenv.lib; {
    description = "An adaptive GTK+ theme based on Material Design";
    homepage = "https://github.com/tista500/Adapta";
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.SShrike ];
  };

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-gtk-theme";
    rev = version;
    sha256 = "0v6v4x3qgf8p6wvvsr8r78ffw7ng5zc0nfnvbdq7hlmw7jir0gd4";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ autoreconfHook parallel sassc inkscape libxml2 glib.dev ];

  buildInputs = [ gdk_pixbuf librsvg gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  configureFlags = "--disable-unity";
}
