{ config, pkgs, ...}:
{
    environment = {

        systemPackages = with pkgs; [
            thunderbird
            protonmail-bridge
        ];
    };
}