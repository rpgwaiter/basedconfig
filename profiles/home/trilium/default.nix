{ config, pkgs, ... }:
{
  services.trilium-server = {
    dataDir = "/mnt/private/nix-config-store/trilium";
    enable = true;
    nginx = {
      enable = true;
      hostName = "notes.based.lan";
    };
  };
}
