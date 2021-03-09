{ pkgs, ... }:

{
  imports = [ ../../secrets/robots-secret.nix ];
  users.users.robots = {
    isNormalUser = true;
    group = "robots";
    uid = 1111;
    extraGroups = [ "storage" "wheel" "docker" "networkmanager" "plugdev" ];
  };
  users.groups.robots.gid = 1111;
  security.sudo.extraRules = [{
    users = [ "robots" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; }];
  }];
}
