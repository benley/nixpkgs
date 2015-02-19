{ stdenv, lib, fetchhg, fetchFromGitHub, protobuf, go, vim }:

let
  alertmanagerVersion = "0.1.0";

  buildFlags = ''
    -ldflags \
      "-X main.buildVersion ${alertmanagerVersion}\
       -X main.buildBranch master\
       -X main.buildUser nix@nixpkgs\
       -X main.buildDate 20150101-00:00:00\
       -X main.goVersion ${lib.getVersion go}"\
  '';

  alertmanagerSrc = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    rev = "942cd35dea6dc406b106d7a57ffe7adbb3b978a5";
    sha256 = "1c14vgn9s0dn322ss8fs5b47blw1g8cxy9w4yjn0f7x2sdwplx1i";
  };

  srcbundle = import ./deps.nix {
    inherit stdenv lib fetchhg fetchFromGitHub alertmanagerSrc;
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
    name = "alertmanagerSrcPhase1";
    src = alertmanagerSrc;
    buildInputs = [ protobuf protoc_gen_go go vim ];
    buildPhase = ''
      protoc --proto_path=$PWD/config --go_out=$PWD/config/generated/ \
        $PWD/config/config.proto
      (
        cd web
        ${stdenv.shell} blob/embed-static.sh static templates \
          | gofmt > blob/files.go
      )
    '';
    installPhase = ''
      cp -a $PWD $out/
    '';
  };
in

  stdenv.mkDerivation rec {
    name = "prometheus-alertmanager-${alertmanagerVersion}";

    src = import ./deps.nix {
      inherit stdenv lib fetchhg fetchFromGitHub;
      alertmanagerSrc = modifiedSrc;
    };

    buildInputs = [ go ];

    buildPhase = ''
      export GOPATH=$src
      go build ${buildFlags} github.com/prometheus/alertmanager
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp alertmanager $out/bin/
    '';

    meta = with lib; {
      description = "Alerting dispather for the Prometheus monitoring system";
      homepage = "https://github.com/prometheus/alertmanager";
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  }
