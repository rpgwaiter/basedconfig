{config, ...}:
{
    fileSystems = {
        "/mnt/public" = {
            device = "192.168.69.111:/mnt/public";
            fsType = "nfs";
            options = [ "x-systemd.automount" "noauto" ];
        };

        "/mnt/private" = {
            device = "192.168.69.111:/mnt/private";
            fsType = "nfs";
            options = [ "x-systemd.automount" "noauto" ];
        };
    };
}