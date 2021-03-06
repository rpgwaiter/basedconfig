{ config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      vscodium
      jetbrains.phpstorm
      jetbrains.pycharm-community
    ];
  };
}
