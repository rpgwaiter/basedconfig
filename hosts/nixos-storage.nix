{ suites, config, lib, pkgs, inputs, ... }:
{
  imports = with suites; lib.concatLists ([ networkStack base nas ]);

  ## ALIASES ##
  environment.shellAliases = {
    upd = "sudo nixos-rebuild switch --upgrade --flake .#nixos-storage";
    cf = "sudo cloudflared tunnel --hostname ssh.based.zone --url ssh://localhost:50022";
  };
  ## END ALIASES ##

  # For later
  # fileSystems."/nix" = {
  #   fsType = "zfs";
  #   device = "basedstorage12tb/encrypted/binarycache";
  #   neededForBoot = true;
  #   options = [ "noatime" ];
  # };

  ## BOOT ##
  boot = {
    loader.grub = { enable = true; version = 2; device = "/dev/sdb"; };
    initrd = {
      availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "mpt3sas" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
  };
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/disk/by-uuid/079628dd-f49e-4c3e-abfa-3bbfb10c65ec"; }];

  ## NETWORKING ##
  networking = {
    hostId = "c4f56373";
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
    interfaces.enp4s0.useDHCP = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8384 3000 ];
    };
  };
  ## END NETWORKING ##

  ## USER SETTINGS ##
  users = {
    motd = "Keep it Based.";
    defaultUserShell = pkgs.fish;
    users.nginx = {
      extraGroups = [ "users" ];
    };
  };
  ## END USER SETTINGS ##

  ## SERVICES ##
  services = {
    syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      dataDir = "/mnt/private/sync";
      configDir = "/mnt/private/nix-config-store/syncthing";
      openDefaultPorts = true;
    };
  };
  ## END SERVICES ##

  ## ACME ##
  # security.acme.email = "rpgwaiter@based.zone";
  # security.acme.acceptTerms = true;
  ## END ACME ##

  ## PROGRAMS ##
  programs = {
    fish = {
      enable = true;
      promptInit = "zfs list";
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  ## END PROGRAMS ##
}
