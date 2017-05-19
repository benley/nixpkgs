{ stdenv, fetchurl, kubernetes }:
let
  arch = if stdenv.isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if stdenv.isLinux
             then "06y8xsnbra95mm6mf84g2s0nnkgy5c9p7fisypjkisy79vq4zxwn"
             else "1gg4dby3kr8rh8msix4p3xbhlb97am8fpvfgx2zk1krg8ymgqrhx";

  pname = "helm";
  version = "2.4.2";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://kubernetes-helm.storage.googleapis.com/helm-v${version}-${arch}.tar.gz";
    sha256 = checksum;
  };

  preferLocalBuild = true;

  buildInputs = [ ];

  propagatedBuildInputs = [ kubernetes ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p $out/bin
  '';

  installPhase = ''
    tar -xvzf $src
    cp ${arch}/helm $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
