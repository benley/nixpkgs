{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.2";
  modDirVersion = "4.2.0";
  extraMeta.branch = "4.2";

  src = /scratch/linux-samus/build/linux-4.2-samus.tar.xz;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  extraConfig = ''
    # drivers/platform/chrome
    CHROME_PLATFORMS y
    CHROMEOS_LAPTOP m
    CHROMEOS_PSTORE m
    CROS_EC_CHARDEV m
    CROS_EC_LPC m
    CROS_EC_PROTO y

    # drivers/input/keyboard
    KEYBOARD_CROS_EC m

    # ??? non-mainline patch?
    BACKLIGHT_CHROMEOS_KEYBOARD m
    LEDS_CHROMEOS_KEYBOARD m

    # drivers/i2c/busses
    I2C_CROS_EC_TUNNEL m

    # drivers/mfd
    MFD_CROS_EC m
    MFD_CROS_EC_I2C m
    MFD_CROS_EC_SPI m
  '';
} // (args.argsOverride or {}))
