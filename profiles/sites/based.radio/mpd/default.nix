{ config, ... }:
{
  services.mpd = {
    enable = true;
    user = "radio";
    group = "radio";
    dataDir = "/mnt/private/nix-config-store/based.radio/mpd";
    # dbFile TODO?
    musidDirectory = "/mnt/public/Radio/music";
  };
}
