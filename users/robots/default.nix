{ pkgs, ... }:

{
  imports = [ ../../secrets/robots-pass.nix ];
  users.users.robots = {
    isNormalUser = true;
    group = "robots";
    uid = 1111;
    openssh.authorizedKeys.keyFiles = [
      (toString ../../secrets/ssh/robots_ed25519.pub)
    ];

    extraGroups = [ "storage" "wheel" "docker" "networkmanager" "plugdev" "adbusers" ];
  };
  users.groups.robots.gid = 1111;
  security.sudo.extraRules = [{
    users = [ "robots" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; }];
  }];
  programs.adb.enable = true;
}
