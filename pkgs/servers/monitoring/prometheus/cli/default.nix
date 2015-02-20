{ stdenv, lib, fetchFromGitHub, fetchhg, go }:

stdenv.mkDerivation rec {
  name = "prometheus-cli-0.2.0";
  src = import ./deps.nix {
    inherit stdenv lib fetchFromGitHub fetchhg;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build github.com/prometheus/prometheus_cli
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp prometheus_cli $out/bin/
  '';

  meta = with lib; {
    description = "Command line tool for querying the Prometheus HTTP API";
    homepage = https://github.com/prometheus/prometheus_cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
