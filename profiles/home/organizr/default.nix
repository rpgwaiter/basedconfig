{ config, pkgs, ... }:
{
  users = {
    users.organizr = {
      isSystemUser = true;
      home = "/var/lib/organizr";
      group = "organizr";
    };
    groups.organizr.members = [ "organizr" ];
  };
  environment.systemPackages = with pkgs; [ mediainfo ffmpeg sox python3 unzip unrar ];
  services.nginx.virtualHosts."home.based.lan" = {
    addSSL = true;
    sslCertificate = "/var/server.crt";
    sslCertificateKey = "/var/server.key";
    root = pkgs.organizr;
    extraConfig = ''
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-XSS-Protection "1; mode=block";
      add_header X-Content-Type-Options "nosniff";
    '';
    locations."/" = { index = "index.php"; };
    locations."/api/v2".extraConfig = ''
      try_files $uri ${pkgs.organizr}/api/v2/index.php$is_args$args;
    '';
    locations."~ \.php$".extraConfig = ''
      fastcgi_pass  unix:${config.services.phpfpm.pools.organizr.socket};
      fastcgi_index index.php;
    '';
  };
  services.phpfpm.pools.organizr = {
    user = "organizr";
    group = "organizr";
    settings = {
      pm = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 1000;
    };
  };
}
