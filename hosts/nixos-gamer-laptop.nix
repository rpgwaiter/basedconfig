{lib, config, pkgs, ... }:
{
  imports = with suites; lib.concatLists [ base desktopStack];

  boot = {
    supportedFilesystems = [ "ntfs"] ;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-intel" ];
  };
  hardware.enableRedistributableFirmware = true;


  environment.shellAliases = {
    upd = "sudo nixos-rebuild switch --upgrade --flake ~/git/basedconfig#nixos-gamer-laptop";
  };
    
  networking = {
    useDHCP = false;
    firewall.enable = true;
    networkmanager.enable = true;
    # interfaces = {
    #   wlo1.useDHCP = true;
    #   enp3s0.useDHCP = true;
    # };
  };
  services.xserver.layout="us";
  

  #swapDevices = [ { device = "/dev/disk/by-label"; }];
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = { 
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
    };
  };

  users.groups.plugdev = {};
  services.udev.extraRules = ''
    # firmware 1.6.0+
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="1011", MODE="0660", GROUP="plugdev"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="1015", MODE="0660", GROUP="plugdev"
    ''
    ;

  # services.basedfilehost = {
  #   enable = true;
  # };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}