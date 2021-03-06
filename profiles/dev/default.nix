{ config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      vscodium
      gitkraken
      jetbrains.phpstorm
      jetbrains.pycharm-community
    ];
  };
}
