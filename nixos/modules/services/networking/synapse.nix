{ config, pkgs, lib, utils, ...}:

with pkgs;
with lib;

let
  cfg = config.services.synapse;

  configOptions = {
    haproxy_config = {
      reload_command = "systemctl reload-or-restart haproxy";
      config_file_path = "/var/lib/synapse/haproxy.cfg";
      socket_file_path = "/var/run/haproxy.sock";
      do_writes = true;
      do_reloads = true;
      do_socket = true;
      global = [];
    };
  };

  synapseConf = writeText "synapse.yaml" (builtins.toJSON configOptions);

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
      #etc."synapse.yaml".text = builtins.toJSON configOptions;
      systemPackages = [
        pkgs.rubyLibs.synapse
        pkgs.haproxy
      ];
    };

    systemd.services.synapse = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ]; #++ systemdDevices;
      #bindsTo = systemdDevices;
      restartTriggers = [
        synapseConf
        #config.environment.etc."synapse.yaml".source
      ];

      serviceConfig = {
        ExecStart = "@${pkgs.rubyLibs.synapse}/bin/synapse -c ${synapseConf}";
        #ExecReload =
        PermissionsStartOnly = true;
        User = "synapse";
      };
    };

    systemd.services.haproxy = {
      description = "HAProxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = "/var/run/haproxy.pid";
        ExecStartPre = "${pkgs.haproxy}/sbin/haproxy -c -q -f ${haproxyCfg}";
        ExecStart = "${pkgs.haproxy}/sbin/haproxy -D -f ${haproxyCfg} -p /var/run/haproxy.pid";
        ExecReload = "-${pkgs.bash}/bin/bash -c \"exec ${pkgs.haproxy}/sbin/haproxy -D -f ${haproxyCfg} -p /var/run/haproxy.pid -sf $MAINPID\"";
      };
    };

  };
}
