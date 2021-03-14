{ config, lib, ... }:
let
  cfg = config.services.myService;
in
{
  options.services.basedRadio = {
    enable = lib.mkEnableOption "Whether to enable BasedRadio";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/basedradio";
      description = "The directory storing the state of the radio";
    };

    instanceName = mkOption {
      type = types.str;
      default = "Radio";
      description = "Instance name used to distinguish between different instances";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The host address to bind to (defaults to localhost).";
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      description = "The port number to bind to.";
    };

    nginx = mkOption {
      default = { };
      description = "Configuration for nginx reverse proxy.";

      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Configure the nginx reverse proxy settings.";
          };

          hostName = mkOption {
            type = types.str;
            description = "The hostname use to setup the virtualhost configuration";
          };
        };
      };
    };

    config = lib.mkIf cfg.enable { };
  };
}
