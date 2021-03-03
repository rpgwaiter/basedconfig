{ suites, config, lib, pkgs, inputs, ... }: 
{
  /*imports = with lib.lists; map (x: ../.  + "/${x}") (flatten [
    (map (x: "users/${x}")    [ "root" "borg" "robots" "storage" "robotsadmin" ])
    (map (x: "profiles/${x}") (flatten ([ "networking/ssh" "media/jellyfin" "home/assistant" 
    "cicd/jenkins" "security/bitwarden" "home/searx" "media/rtorrent" "media/rutorrent" 
    "media/jellyfin" "media/plex" "cicd/gitea" "backups/borg/storage" "webserver/nginx"
    "filesystems/export-nfs" "filesystems/export-smb" "filesystems/mount-zfs" "networking/unifi"
      (map (x: "docker/${x}") [ "registry" "trilium" ])
    ]))) ## This is probably really bad idk, saves a small amount of space though
  ]);*/

  imports = with suites; [ base mediaHost nas ];

  ## ALIASES ##
  environment.shellAliases = {
    upd = "sudo nixos-rebuild switch --upgrade --flake /home/robots/git/basedconfig-ng#nixos-storage";
    cf = "sudo cloudflared tunnel --hostname ssh.based.zone --url ssh://localhost:50022";
  };  
  ## END ALIASES ##
    
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
  fileSystems."/" = { device="/dev/disk/by-label/nixos"; fsType="ext4"; };
  swapDevices = [{device="/dev/disk/by-uuid/079628dd-f49e-4c3e-abfa-3bbfb10c65ec";}];

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