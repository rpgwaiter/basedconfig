{ config, lib, pkgs, ... }:
{
  environment = {

    systemPackages = with pkgs; [
      discord
      tdesktop
      signal-desktop
      thunderbird-bin
    ];

  };
}
