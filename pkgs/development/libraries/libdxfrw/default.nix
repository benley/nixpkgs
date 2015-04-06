{ stdenv, fetchurl, python, swig3, automake, autoconf, libtool
, autoconf-archive, file }:

stdenv.mkDerivation rec {
  name = "libdxfrw-${version}";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/libdxfrw/libdxfrw-${version}.tar.bz2";
    sha256 = "1wvmc8dkzi4iff33p0mv9gdskipcmr4bqmqb1d6y8wsjm0mkbjrf";
  };

  preConfigure = "mkdir -p m4; autoreconf -fi -Wall";

  buildInputs = [ file python swig3 automake autoconf libtool autoconf-archive ];

  enableParallelBuilding = true;
}
