{ config, pkgs, lib, utils, ...}:

with pkgs;
with lib;

let
  cfg = config.services.synapse;

  configOptions = {
    haproxy_config = {
      reload_command = "systemctl reload-or-restart haproxy";
      config_file_path = "...";
      socket_file_path = "...";
      do_writes = true;
      do_reloads = true;
      do_socket = true;
      global = [];
    };
  };

  conf = writeText "synapse.yaml" ''
    blahblah: blahblah
    etc: blahblah
  '';

  #devices = attrValues (filterAttrs (_: i: i != null) cfg.interface);
  #systemdDevices = flip map devices
  #  (i: "sys-subsystem-net-devices-${utils.escapeSystemdPath i}.device");

in {

  options.services.synapse = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the Synapse service discovery daemon.
      '';
    };
    #config = mkOption {
    #  type = types.lines;
    #  description = ''
    #    Contents added to the synapse config file.
    #  '';
    #};

  };

  config = mkIf cfg.enable {
    users.extraUsers."synapse" = {
      description = "Synapse agent daemon user";
      uid = config.ids.uids.synapse;
    };

    environment = {
      etc."synapse.yaml".text = builtins.toJSON configOptions;
      systemPackages = with pkgs; [ rubyLibs.synapse ];
    };

    systemd.services.synapse = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ]; #++ systemdDevices;
      #bindsTo = systemdDevices;
      restartTriggers = [
        config.environment.etc."synapse.yaml".source
        ];

      serviceConfig = {
        ExecStart = "@${pkgs.rubyLibs.synapse}/bin/synapse -c ${conf}";
        #ExecReload =
        PermissionsStartOnly = true;
        User = "synapse";
      };
    };
  };
}
