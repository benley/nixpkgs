{ stdenv, lib, fetchFromGitHub, fetchhg, pushgatewaySrc }:

let
  goDeps = [
    {
      root = "code.google.com/p/goprotobuf";
      src = fetchhg {
        url = "https://code.google.com/p/goprotobuf";
        rev = "267";
        sha256 = "0kamslfmxs6hi9ww52izmsq48ldaf67xawwhzwwdsbslhv0b9lf7";
      };
    }
    {
      root = "github.com/golang/glog";
      src = fetchFromGitHub {
        owner = "golang";
        repo = "glog";
        rev = "44145f04b68cf362d9c4df2182967c2275eaefed";
        sha256 = "1k7sf6qmpgm0iw81gx2dwggf9di6lgw0n54mni7862hihwfrb5rq";
      };
    }
    {
      root = "github.com/golang/protobuf";
      src = fetchFromGitHub {
        owner = "golang";
        repo = "protobuf";
        rev = "5677a0e3d5e89854c9974e1256839ee23f8233ca";
        sha256 = "18dzxmy0gfjnwa9x8k3hv9calvmydv0dnz1iibykkzd20gw4l85v";
      };
    }
    {
      root = "github.com/julienschmidt/httprouter";
      src = fetchFromGitHub {
        owner = "julienschmidt";
        repo = "httprouter";
        rev = "57ead30b068c74ac89c121814d1234d4727eaf5b";
        sha256 = "00q2xwfg3s9jj0f09zhr4qa6xg50va1arqgdsdk6cm3255kp605x";
      };
    }
    {
      root = "github.com/matttproud/golang_protobuf_extensions";
      src = fetchFromGitHub {
        owner = "matttproud";
        repo = "golang_protobuf_extensions";
        rev = "7a864a042e844af638df17ebbabf8183dace556a";
        sha256 = "0vb547ljhwj0qkmcj6pg47iqzy69p6isaryaph8wmlqwsvbx3di4";
      };
    }
    {
      root = "github.com/miekg/dns";
      src = fetchFromGitHub {
        owner = "miekg";
        repo = "dns";
        rev = "b65f52f3f0dd1afa25cbbf63f8e7eb15fb5c0641";
        sha256 = "1hwia27rmyc9373g4dwc9z0jkka3w2i0i2zic4ybk9ac9limp9jv";
      };
    }
    {
      root = "github.com/onsi/ginkgo";
      src = fetchFromGitHub {
        owner = "onsi";
        repo = "ginkgo";
        rev = "17ea479729ee427265ac1e913443018350946ddf";
        sha256 = "09vgwayw9ip5qgxlv2abwvxs88wgcs2fc6lh74160li5zyf8i97x";
      };
    }
    {
      root = "github.com/onsi/gomega";
      src = fetchFromGitHub {
        owner = "onsi";
        repo = "gomega";
        rev = "8adf9e1730c55cdc590de7d49766cb2acc88d8f2";
        sha256 = "1rf6cxn50d1pji3pv4q372s395r5nxwcgp405z2r2mfdkri4v3w4";
      };
    }
    {
      root = "github.com/prometheus/client_golang";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "client_golang";
        rev = "c70db11f1ee77a34066aa41345dca4b105c2ed06";
        sha256 = "16y7iadix97j17rglfphv5bx6vcd4zp0wrvminaqvmdb85asz64v";
      };
    }
    {
      root = "github.com/prometheus/client_model";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "client_model";
        rev = "bc9454ca562dc050e060ea61a1c0e562a189850f";
        sha256 = "1a5izpyxns93m486s7n2j463ffak6amqnp1kr43a9a7d8fh6q48a";
      };
    }
    {
      root = "github.com/prometheus/procfs";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "procfs";
        rev = "92faa308558161acab0ada1db048e9996ecec160";
        sha256 = "0kaw81z2yi45f6ll6n2clr2zz60bdgdxzqnxvd74flynz4sr0p1v";
      };
    }
    {
      root = "github.com/prometheus/prometheus";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "prometheus";
        rev = "fd9ee9b0099d82a1019b04329f3952905480dd68";
        sha256 = "13h0jv251czbgdqbb7khw13vfqssy6qi8qzbmmy2ccgb9s6rfapb";
      };
    }
    {
      root = "github.com/prometheus/pushgateway";
      src = pushgatewaySrc;
    }
    {
      root = "github.com/syndtr/goleveldb";
      src = fetchFromGitHub {
        owner = "syndtr";
        repo = "goleveldb";
        rev = "e9e2c8f6d3b9c313fb4acaac5ab06285bcf30b04";
        sha256 = "0vg3pcrbdhbmanwkc5njxagi64f4k2ikfm173allcghxcjamrkwv";
      };
    }
    {
      root = "github.com/syndtr/gosnappy";
      src = fetchFromGitHub {
        owner = "syndtr";
        repo = "gosnappy";
        rev = "ce8acff4829e0c2458a67ead32390ac0a381c862";
        sha256 = "0ywa52kcii8g2a9lbqcx8ghdf6y56lqq96sl5nl9p6h74rdvmjr7";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}
