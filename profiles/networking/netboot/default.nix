{ config, pkgs, ...}:
{
    services.pixiecore = {
        port = 65000;
        dhcpNoBind = true;
        listen = "192.168.69.112";
        
        openFirewall = true;
    };
}