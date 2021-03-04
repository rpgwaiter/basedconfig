{ config, pkgs, ... }:
{
    services.unifi = {
        enable = true;
        jrePackage = pkgs.jre8_headless;
        unifiPackage = pkgs.unifi;
        dataDir = "/mnt/private/nix-config-store/unifi";
        openPorts = true;
    };
    networking.firewall.allowedTCPPorts = [8443];
}