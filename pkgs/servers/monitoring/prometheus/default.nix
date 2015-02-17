{ stdenv, lib, fetchhg, fetchFromGitHub, protobuf, go, vim }:

let
  prometheusVersion = "0.10.0";
  prometheusRev = "f5a0f7fa185dae2c772a5847a7aac9ba33b545f9";

  # Metadata that gets embedded into the binary
  buildFlags = ''
    -ldflags \
      "-X main.buildVersion ${prometheusVersion}\
       -X main.buildRevision ${builtins.substring 0 6 prometheusRev}\
       -X main.buildBranch master\
       -X main.buildUser nix@nixpkgs\
       -X main.buildDate 20150101-00:00:00\
       -X main.goVersion ${lib.getVersion go}"\
  '';

  prometheusSrc = fetchFromGitHub {
    owner = "prometheus";
    repo = "prometheus";
    rev = prometheusRev;
    sha256 = "1wagmr4bca8fbvi48n9p4hdnx1m4chyaa1bzman6dhqfmkiikf5q";
  };

  srcbundle = import ./deps.nix {
    inherit stdenv lib fetchhg fetchFromGitHub prometheusSrc;
  };

  protoc_gen_go = stdenv.mkDerivation rec {
    name = "protoc-gen-go";
    src = srcbundle;
    buildInputs = [ go ];
    buildPhase = ''
      export GOPATH=$src
      go build github.com/golang/protobuf/protoc-gen-go
    '';
    installPhase = ''
      mkdir -p $out/bin;
      cp protoc-gen-go $out/bin/
    '';
  };

  # Build phase 1: Generate compiled protobufs and the web assets blob
  modifiedSrc = stdenv.mkDerivation rec {
    name = "promsrc";
    src = prometheusSrc;
    buildInputs = [ protobuf protoc_gen_go go vim ];
    buildPhase = ''
      protoc --proto_path=$PWD/config --go_out=$PWD/config/generated/ \
        $PWD/config/config.proto
      (
        cd web
        ${stdenv.shell} ../utility/embed-static.sh static templates \
          | gofmt > blob/files.go
      )
    '';
    installPhase = ''
      cp -a $PWD $out/
    '';
  };

in

stdenv.mkDerivation rec {
  name = "prometheus-${prometheusVersion}";

  src = import ./deps.nix {
    inherit stdenv lib fetchhg fetchFromGitHub;
    prometheusSrc = modifiedSrc;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build ${buildFlags} github.com/prometheus/prometheus
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp prometheus $out/bin/
  '';

  meta = with lib; {
    description = "Service monitoring system and time series database";
    homepage = http://prometheus.github.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
