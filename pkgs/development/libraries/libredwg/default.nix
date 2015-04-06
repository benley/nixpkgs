{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig
, libxml2, dejagnu, python, swig, texinfo }:

stdenv.mkDerivation rec {
  name = "libredwg-${version}";
  version = "0.4-dev";

  src = fetchgit {
    url = git://git.savannah.gnu.org/libredwg.git;
    rev = "f2cc8f05fc8b06f4232a82a91a07acee7ed7cf19";
    sha256 = "0kicc7wq2cfj92w7gm1szxgfjgf45q650fjq17ba71xsd19agc61";
  };

  buildInputs = [
    autoconf automake dejagnu libtool libxml2 pkgconfig python
    swig texinfo
  ];

  enableParallelBuilding = true;

  preConfigure = "${stdenv.shell} ./autogen.sh";

  configureFlags = "--enable-write";
}
