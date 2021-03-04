{config, pkgs, lib, ... }:

let borgbackupMonitor = { config, pkgs, lib, ... }: with lib; {
  key = "borgbackupMonitor";
  _file = "borgbackupMonitor";
  config.systemd.services = {
    "notify-problems@" = {
      enable = true;
      serviceConfig.User = "robots";
      environment.SERVICE = "%i";
      script = ''
        export $(cat /proc/$(${pkgs.procps}/bin/pgrep "gnome-session" -u "$USER")/environ |grep -z '^DBUS_SESSION_BUS_ADDRESS=')
        ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -u $SERVICE for details"
      '';
    };

  } // flip mapAttrs' config.services.borgbackup.jobs (name: value:
    nameValuePair "borgbackup-job-${name}" {
      unitConfig.OnFailure = "notify-problems@%i.service";
      preStart = lib.mkBefore ''
        # waiting for internet after resume-from-suspend
        until /run/wrappers/bin/ping nas.based.lan -c1 -q >/dev/null; do :; done
      '';
    }
  );

  # optional, but this actually forces backup after boot in case laptop was powered off during scheduled event
  # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
  config.systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (name: value:
    nameValuePair "borgbackup-job-${name}" {
      timerConfig.Persistent = true;
    }
  );
};
in {
  imports =
  [
    borgbackupMonitor
  ];
  services.borgbackup.jobs = 
    let basicBorgJob = name: {
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/robots/.ssh/id_ed25519";
      environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "1";
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      repo = "ssh://robots@nas:50022/mnt/private/Backups/borg/${name}";
      compression = "zstd,1";
      startAt = "daily";
      user = "robots";
    };
    in
    {
      home = basicBorgJob "nixos-gamer-laptop" // rec { paths = "/home/robots"; };
    };
}
 