{config, pkgs, lib, ... }:
{
    services.borgbackup = {
        repos.nixos-gamer-laptop = {
            path = "/mnt/private/Backups/borg/nixos-gamer-laptop";
            authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5J/xljrCYFvOcJOJazkmwCTgksNoQuIQDVZACu0sX7"];
            group = "storage";
        };
        # repos.nixos-storage = {
        #     path = "/mnt/private/Backups/borg/storage";
        #     authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5J/xljrCYFvOcJOJazkmwCTgksNoQuIQDVZACu0sX7"];
        #     user = "robots";
        #     group = "robots";
        # };
        jobs = 
        let job = {
            encryption.mode = "none";
            repo = "/mnt/private/Backups/borg/storage";
            compression = "zstd,1";
            startAt = "daily";
            environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "1";
            extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
        };
        common-excludes = [
          # Largest cache dirs
          ".cache"
          "*/cache2" # firefox
          "*/Cache"
          ".config/Code/CachedData"
          ".container-diff"
          ".npm/_cacache"
          # Work related dirs
          "*/node_modules"
          "*/_build"
          "*/venv"
          "*/.venv"
        ];
        in
        {
            home = job // rec {
                paths = "/home/robots";
                startAt = "weekly";
                exclude = map (x: paths + "/" + x) common-excludes;
            };
            varlib = job // rec { 
                paths = "/var/lib"; 
                exclude = map (x: paths + "/" + x) common-excludes; 
            };
        };
    };
}
 