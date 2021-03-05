{config, pkgs, ...}:
{
    environment.systemPackages = with pkgs; [mediainfo ffmpeg sox python3 unzip unrar];
    services.nginx.virtualHosts."torrents.based.lan" = {
        addSSL = true;
        sslCertificate = "/var/server.crt";
        sslCertificateKey = "/var/server.key";
        root = "${pkgs.rutorrent}";
        extraConfig = ''
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Content-Type-Options "nosniff";
        '';
        locations."/" = {  index = "index.html"; };
        locations."/RPC2" = {
            extraConfig = ''
            include scgi_params;
            scgi_pass localhost:5000;
        '';
        };
        locations."~ \.php$".extraConfig = ''
            fastcgi_pass  unix:${config.services.phpfpm.pools.media.socket};
            fastcgi_index index.php;
        '';
    };
}