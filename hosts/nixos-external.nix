{ suites, config, lib, pkgs, ... }:
{
  imports = suites.base ++ [ ../secrets/external-networking.nix ];

  ## ALIASES ##
  environment.shellAliases = {
    upd = "sudo nixos-rebuild switch --flake .#nixos-external";
  };
  ## END ALIASES ##

  ## BOOT ##
  boot = {
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "/dev/vda";
    initrd = {
      availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
      kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
      postDeviceCommands =
        ''
          # Set the system time from the hardware clock to work around a
          # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
          # to the *boot time* of the host).
          hwclock -s
        '';
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };
  security.rngd.enable = lib.mkDefault false;
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };

  ## USER SETTINGS ##
  users = {
    motd = "Keep it Based.";
    defaultUserShell = pkgs.fish;
  };
  ## END USER SETTINGS ##

}
