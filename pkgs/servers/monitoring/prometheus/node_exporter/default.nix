{ stdenv, lib, fetchFromGitHub, fetchhg, go }:

stdenv.mkDerivation rec {
  name = "prometheus-node-exporter-0.7.1";
  src = import ./deps.nix {
    inherit stdenv lib fetchFromGitHub fetchhg;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build github.com/prometheus/node_exporter
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp node_exporter $out/bin/
  '';

  meta = with lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = https://github.com/prometheus/node_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
