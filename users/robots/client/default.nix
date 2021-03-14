{ config, ... }:
{
  home-manager.users.robots.programs.ssh = {
    enable = true;

    matchBlocks = {
      "nixos-storage" = {
        host = "nas";
        identityFile = "/home/robots/ssh/id_ed25519";
        identitiesOnly = true;
        extraOptions = { AddKeysToAgent = "yes"; };
      };
      "github.com" = {
        host = "github.com";
        identityFile = toString ../secrets/ssh/robots_ed25519;
        identitiesOnly = true;
        extraOptions = { AddKeysToAgent = "yes"; };
      };
    };
  };
}
