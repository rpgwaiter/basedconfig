{ config, lib, pkgs, ... }:
{
    services = {
        gnome3.core-os-services.enable = true;
        xserver = {
            enable = true;
            libinput.enable = true;
            
            displayManager = {
                gdm.enable = true;
            };
            desktopManager = {
                gnome3.enable = true;
            };
            
        };
    };
    environment = {
        systemPackages = with pkgs; [
            cyberpunk-neon
            firefox-devedition-bin
            konsole
            plasma-browser-integration   
            keepassxc
            ledger-live-desktop
            gnome3.gnome-tweaks
            gnomeExtensions.paperwm
            libreoffice-fresh
            trilium-desktop
            bitwarden
            lxappearance
        ];
    };
    sound.enable = true;
    hardware.pulseaudio.enable = true;
}