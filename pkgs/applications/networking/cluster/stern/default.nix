{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

let version = "1.5.0"; in

buildGoPackage {
  name = "stern-${version}";

  goPackagePath = "github.com/wercker/stern";

  src = fetchFromGitHub {
    rev = version;
    owner = "wercker";
    repo = "stern";
    sha256 = "0w4lvxlcvrvwszfcajdnbz8zcvyz30lnb34cyhfh0avmn0143vkr";
  };
}
