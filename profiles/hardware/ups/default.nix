{ config, ... }:
{
    power.ups = {
        enable = true;
        ups."serverups" = {
            driver = "usbhid-ups";
            port = "auto";
            description = "Server UPS";
        };
    };

    users.groups.nut = {};
    users.users.local_mon = {
        group = "nut";
        isNormalUser = false;
        isSystemUser = true;
        createHome = true;
        home = "/var/lib/nut";
    };
}