{ config, pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    port = 8123;
    configDir = "/mnt/private/nix-config-store/home-assistant";
    openFirewall = true;
    package = (pkgs.home-assistant.override {
      extraPackages = py: with py; [ psycopg2 ];
    });
    config.recorder.db_url = "postgresql://@/hass";
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "hass" ];
    ensureUsers = [{
      name = "hass";
      ensurePermissions = {
        "DATABASE hass" = "ALL PRIVILEGES";
      };
    }];
    dataDir = "/mnt/private/nix-config-store/postgresql";
  };
  services.nginx.virtualHosts."assistant.based.lan" = {
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
        proxy_pass http://127.0.0.1:8123;
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };
}
