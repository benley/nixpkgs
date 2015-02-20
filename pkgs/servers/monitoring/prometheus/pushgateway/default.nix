{ stdenv, lib, fetchFromGitHub, fetchhg, goPackages }:

with goPackages;

let
  version = "0.1.0";
  rev = "3f1d42dade342ddb88381607358bae61a0a6b6c7";

  pushgatewaySrc = fetchFromGitHub {
    owner = "prometheus";
    repo = "pushgateway";
    rev = rev;
    sha256 = "1wqxbl9rlnxszp9ylvdbx6f5lyj2z0if3x099fnjahbqmz8yhnf4";
  };

  modifiedSrc = stdenv.mkDerivation rec {
    name = "pushgatewaySrcPhase1";
    src = pushgatewaySrc;
    buildInputs = [ go go-bindata ];
    buildPhase = ''
      go-bindata resources/
    '';
    installPhase = ''
      cp -a $PWD $out/
    '';
  };

  buildFlags = ''
    -ldflags \
      "-X main.buildVersion ${version}\
       -X main.buildRev ${rev}\
       -X main.buildBranch master\
       -X main.buildUser nix@nixpkgs\
       -X main.buildDate 20150101-00:00:00\
       -X main.goVersion ${lib.getVersion go}"\
  '';

in

  stdenv.mkDerivation rec {
    name = "prometheus-pushgateway-${version}";
    src = import ./deps.nix {
      inherit stdenv lib fetchFromGitHub fetchhg;
      pushgatewaySrc = modifiedSrc;
    };

    buildInputs = [ go ];

    buildPhase = ''
      export GOPATH=$src
      go build ${buildFlags} github.com/prometheus/pushgateway
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp pushgateway $out/bin/
    '';

    meta = with lib; {
      description =
        "Allows ephemeral and batch jobs to expose metrics to Prometheus";
      homepage = https://github.com/prometheus/pushgateway;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  }
