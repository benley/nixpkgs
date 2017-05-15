{ stdenv, lib, buildGoPackage, fetchFromGitHub, go-bindata  }:

buildGoPackage rec {
  name = "kops-${version}";
  version = "1.6.0-beta.1";

  goPackagePath = "k8s.io/kops";

  src = fetchFromGitHub {
    rev = version;
    owner = "kubernetes";
    repo = "kops";
    sha256 = "0fh8m6kxcahpgpphmrvbyvvxhv1fkq6lm8nj5vk754czr3hlggyn";
  };

  buildInputs = [go-bindata];
  subPackages = ["cmd/kops"];

  buildFlagsArray = ''
    -ldflags=
        -X k8s.io/kops.Version=${version}
        -X k8s.io/kops.GitVersion=${version}
  '';

  preBuild = ''
    (cd go/src/k8s.io/kops
     go-bindata -o upup/models/bindata.go -pkg models -prefix upup/models/ upup/models/...
     go-bindata -o federation/model/bindata.go -pkg model -prefix federation/model federation/model/...)
  '';

  meta = with stdenv.lib; {
    description = "Easiest way to get a production Kubernetes up and running";
    homepage = https://github.com/kubernetes/kops;
    license = licenses.asl20;
    maintainers = with maintainers; [offline];
  };
}
