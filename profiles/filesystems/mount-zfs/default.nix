{ config, pkgs, lib, ... }:
let 
  vols = [ "public" "private" ] ++ (map (n: "public/${n}") [
    "Anime" "Games" "Movies"
    "Games" "Music" "OS" "TV"
    "Radio" "Software" "Standup"
  ]) ++ (map (n: "private/${n}") [ "Backups" "Repo" "VideoProduction" ]);
  stdmount = path: {
    fsType = "zfs";
    device = "basedstorage12tb/encrypted/${path}";
  };
  names = map (n: "/mnt/${n}") vols;
  values = map stdmount vols;
  mounts = builtins.listToAttrs (
    lib.lists.zipListsWith (name: value: { inherit name value; }) names values
  );
in
{
  fileSystems = mounts;
  services.zfs.autoScrub.enable = true;
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      enableUnstable = true;
      requestEncryptionCredentials = true;
    };
  };
}