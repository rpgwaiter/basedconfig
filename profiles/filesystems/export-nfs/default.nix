{ config, ... }:

{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/public *(rw,no_subtree_check,crossmnt)
      /mnt/private *(rw,no_subtree_check,nohide,crossmnt)
  '';
  };

  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 445 139 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  fileSystems."/srv/vault" = {
    device = "/mnt/public";
    options = [ "bind" ];
  };
}