{ stdenv
, fetchFromGitHub
, lib
}:
stdenv.mkDerivation rec {
  pname = "r8152-udev-rules";
  version = "2.19.2";

  src = fetchFromGitHub {
    owner = "wget";
    repo = "realtek-r8152-linux";
    rev = "v${version}";
    sha256 = "sha256-9kJF7y1T0/5yxxsIrQycKY53Ksd8JxMEpVXNjX0WRao=";
  };

  # We don't want to build the kernel module
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/udev/rules.d
    cp 50-usb-realtek-net.rules $out/etc/udev/rules.d/
    runHook postInstall
  '';

  meta = {
    description = "Udev rules for Realtek RTL8152 family of USB Ethernet adapters.";
    longDescription = ''
      Support for RTL8152 / RTL8153 / RTL8154 / RTL8156 / RTL8157 / RTL8159 USB
      ethernet interfaces. This package only installs udev rules! The actual
      driver is included in the upstream Linux kernel.
    '';
    license = lib.licenses.gpl2Only;
    homepage = "https://www.realtek.com/Download/List?cate_id=585";
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.linux;
  };
}
