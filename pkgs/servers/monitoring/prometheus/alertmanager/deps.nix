{ stdenv, lib, fetchFromGitHub, fetchhg, alertmanagerSrc }:

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
      root = "github.com/howeyc/fsnotify";
      src = fetchFromGitHub {
        owner = "howeyc";
        repo = "fsnotify";
        rev = "4894fe7efedeeef21891033e1cce3b23b9af7ad2";
        sha256 = "09r3h200nbw8a4d3rn9wxxmgma2a8i6ssaplf3zbdc2ykizsq7mn";
      };
    }
    {
      root = "github.com/julienschmidt/httprouter";
      src = fetchFromGitHub {
        owner = "julienschmidt";
        repo = "httprouter";
        rev = "bde5c16eb82ff15a1734a3818d9b9547065f65b1";
        sha256 = "1l74pvqqhhval4vfnhca9d6i1ij69qs3ljf41w3m1l2id42rq7r9";
      };
    }
    {
      root = "github.com/matttproud/golang_protobuf_extensions";
      src = fetchFromGitHub {
        owner = "matttproud";
        repo = "golang_protobuf_extensions";
        rev = "ba7d65ac66e9da93a714ca18f6d1bc7a0c09100c";
        sha256 = "1vz6zj94v90x8mv9h6qfp1211kmzn60ri5qh7p9fzpjkhga5k936";
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
        rev = "5ed93e443a4b7dfe9f5e95ca87e6082e503021d2";
        sha256 = "0ghrx5qmgvgb8cbvsj53v1ir4j9agilg4wyhpk5ikqdv6mmqly4h";
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
      root = "github.com/prometheus/alertmanager";
      src = alertmanagerSrc;
    }
    {
      root = "github.com/prometheus/client_golang";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "client_golang";
        rev = "4627d59e8a09c330c5ccfe7414baca28d8df847d";
        sha256 = "1mmj1r8xfi1gwb5f0l6sxjj804dhavp3pjmrqpbaa1g82bmz1hr1";
      };
    }
    {
      root = "github.com/prometheus/client_model";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "client_model";
        rev = "fa8ad6fec33561be4280a8f0514318c79d7f6cb6";
        sha256 = "11a7v1fjzhhwsl128znjcf5v7v6129xjgkdpym2lial4lac1dhm9";
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
        rev = "13048b7468b75b4bdb8a75be54dfd4a24b03131a";
        sha256 = "0n8qq4x3p8x885wl5agrzl8iqcmllrgyjrnzx9y10c3xh694xhrh";
      };
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
    {
      root = "github.com/thorduri/pushover";
      src = fetchFromGitHub {
        owner = "thorduri";
        repo = "pushover";
        rev = "a8420a1935479cc266bda685cee558e86dad4b9f";
        sha256 = "0j4k43ppka20hmixlwhhz5mhv92p6wxbkvdabs4cf7k8jpk5argq";
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
