{ config, ... }:
{
  home-manager.users.robots.programs.ssh = {
    enable = true;

    matchBlocks = {
      "nixos-storage" = {
        host = "nas";
        identityFile = toString ../secrets/ssh/robots_ed25519;
        identitiesOnly = true;
        extraOptions = { AddKeysToAgent = "yes"; };
      };
    };
  };
}
