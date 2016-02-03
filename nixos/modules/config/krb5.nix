{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.krb5;

in

{
  ###### interface

  options = {

    krb5 = {

      enable = mkOption {
        default = false;
        description = "Whether to enable Kerberos V.";
      };

      defaultRealm = mkOption {
        type = types.str;
        description = "Default realm.";
      };

      domainRealm = mkOption {
        type = types.str;
        description = "Default domain realm.";
      };

      kdcs = mkOption {
        type = types.nullOr (types.listOf types.str);
        description = "List of Kerberos domain controllers.";
        default = null;
      };

      kerberosAdminServer = mkOption {
        type = types.nullOr types.str;
        description = "Kerberos admin server.";
        default = null;
      };

    };

  };

  ###### implementation

  config = mkIf config.krb5.enable {

    environment.systemPackages = [ pkgs.krb5Full ];

    environment.etc."krb5.conf".text =
      ''
        [libdefaults]
            default_realm = ${cfg.defaultRealm}
            encrypt = true

        # The following krb5.conf variables are only for MIT Kerberos.
            krb4_config = /etc/krb.conf
            krb4_realms = /etc/krb.realms
            kdc_timesync = 1
            ccache_type = 4
            forwardable = true
            proxiable = true

        # The following encryption type specification will be used by MIT Kerberos
        # if uncommented.  In general, the defaults in the MIT Kerberos code are
        # correct and overriding these specifications only serves to disable new
        # encryption types as they are added, creating interoperability problems.

        #   default_tgs_enctypes = aes256-cts arcfour-hmac-md5 des3-hmac-sha1 des-cbc-crc des-cbc-md5
        #   default_tkt_enctypes = aes256-cts arcfour-hmac-md5 des3-hmac-sha1 des-cbc-crc des-cbc-md5
        #   permitted_enctypes = aes256-cts arcfour-hmac-md5 des3-hmac-sha1 des-cbc-crc des-cbc-md5

        # The following libdefaults parameters are only for Heimdal Kerberos.
            v4_instance_resolve = false
            v4_name_convert = {
                host = {
                    rcmd = host
                    ftp = ftp
                }
                plain = {
                    something = something-else
                }
            }
            fcc-mit-ticketflags = true

      ''
      + (optionalString ((!builtins.isNull cfg.kdcs) ||
                         (!builtins.isNull cfg.kerberosAdminServer))
         ''
           [realms]
               ${cfg.defaultRealm} = {
         '')
      + (optionalString (!builtins.isNull cfg.kdcs)
          (builtins.concatStringsSep ""
            (map (x: "      kdc = ${x}\n") cfg.kdcs)))
      + (optionalString (!builtins.isNull cfg.kerberosAdminServer)
         "      admin_server = ${cfg.kerberosAdminServer}\n")
      + (optionalString ((!builtins.isNull cfg.kdcs) ||
                         (!builtins.isNull cfg.kerberosAdminServer))
         "    }\n")
      + ''

        [domain_realm]
            .${cfg.domainRealm} = ${cfg.defaultRealm}
            ${cfg.domainRealm} = ${cfg.defaultRealm}

        [logging]
            kdc = SYSLOG:INFO:DAEMON
            admin_server = SYSLOG:INFO:DAEMON
            default = SYSLOG:INFO:DAEMON
            krb4_convert = true
            krb4_get_tickets = false

        [appdefaults]
            pam = {
                debug = false
                ticket_lifetime = 36000
                renew_lifetime = 36000
                max_timeout = 30
                timeout_shift = 2
                initial_timeout = 1
            }
      '';
  };
}
