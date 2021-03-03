{ config, pkgs, ... }:
{
    imports = [../.];
    services.rtorrent = {
        enable = true;
        openFirewall = true;
        user = "media";
        group = "storage";
        downloadDir = "/mnt/public";
        dataDir = "/mnt/private/nix-config-store/rtorrent";
    };
}