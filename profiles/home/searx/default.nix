{ config, pkgs, ... }:
{
  services.searx = {
    enable = true;
  };
  services.nginx.virtualHosts."search.based.lan" = {
    addSSL = true;
    sslCertificate = "/var/server.crt";
    sslCertificateKey = "/var/server.key";
    extraConfig = ''
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-XSS-Protection "1; mode=block";
      add_header X-Content-Type-Options "nosniff";
    '';
    locations."/" = {
      extraConfig = ''
        proxy_pass http://127.0.0.1:8888/;
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
