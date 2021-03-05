{ config, pkgs, ... }:
{
    services.bitwarden_rs = {
        enable = true;
        backupDir = "/mnt/private/nix-config-store/bitwarden";
        config = {
            domain = "https://bitwarden.based.lan";
            signupsAllowed = true;
            rocketPort = 8222;
            rocketLog = "critical";
        };
    };
    services.nginx.virtualHosts."bitwarden.based.lan" = {
        addSSL = true;
        sslCertificate = "/var/bitwarden2.crt";
        sslCertificateKey = "/var/bitwarden.based.lan.key";
        sslTrustedCertificate = "/var/myCA.pem";
        extraConfig = ''
            ssl_password_file /var/no;
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Content-Type-Options "nosniff";
        '';
        locations."/" = {
            extraConfig = ''
                proxy_pass http://127.0.0.1:8222/;
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
    networking.firewall.allowedTCPPorts = [8222];
}