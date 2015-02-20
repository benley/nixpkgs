{ stdenv, lib, fetchFromGitHub, fetchhg, go }:

stdenv.mkDerivation rec {
  name = "prometheus-haproxy-exporter-0.4.0";

  src = import ./deps.nix {
    inherit stdenv lib fetchFromGitHub fetchhg;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build github.com/prometheus/haproxy_exporter
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp haproxy_exporter $out/bin/
  '';

  meta = with lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/haproxy_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
