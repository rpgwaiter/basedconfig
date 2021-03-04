{ config, ... }:
{
    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
        };
        grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            useOSProber = true;
            # ipxe = { 
            #     demo = ''
            #         #!ipxe
            #         dhcp
            #         chain http://boot.ipxe.org/demo/boot.php
            #     '';
            # };
        };
    };
}