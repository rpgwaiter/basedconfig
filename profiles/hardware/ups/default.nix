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
}