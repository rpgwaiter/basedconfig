{ config, ... }:
{
    services.jellyfin.enable = true;
    networking.firewall = {allowedTCPPorts = [8096]; allowedUDPPorts = [8096];};
    services.nginx.virtualHosts."stream.based.zone" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
            extraConfig = ''
                proxy_pass http://127.0.0.1:8096/;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Protocol $scheme;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_buffering off;
            '';
        };
    };
}