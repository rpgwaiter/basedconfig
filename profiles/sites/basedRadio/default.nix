{ config, ... }:
{
  users.users.radio = {
    isSystemUser = true;
    group = "radio";
    home = "/mnt/private/nix-config-store/basedradio";
  };
  users.groups.radio = { };
}
