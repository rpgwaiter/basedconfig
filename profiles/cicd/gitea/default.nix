{ config, ... }:
{
    services.gitea = {
        enable = true;
        appName = "BasedGit";
        rootUrl = "http://git.based.zone";
        httpPort = 3030;
        ssh.clonePort = 50022;
        #stateDir = "/mnt/private/nix-config-store/gitea";
        domain = "ssh.based.zone";
    };
    services.nginx.virtualHosts."git.based.zone" = {
        addSSL = true;
        enableACME = true;
        extraConfig = ''
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Content-Type-Options "nosniff";
        '';
        locations."/" = {
            extraConfig = ''
                proxy_pass http://127.0.0.1:${toString config.services.gitea.httpPort}/;
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