{ config, pkg, ... }:
{
  virtualisation.oci-containers.containers = {
    trilium = {
      image = "zadam/trilium:0.45.10";
      ports = [ "2345:8080" ];
      volumes = [ "/mnt/private/nix-config-store/trilium:/root/trilium-data" ];
    };
  };
  services.nginx.virtualHosts."notes.based.lan" = {
    addSSL = true;
    sslCertificate = "/var/server.crt";
    sslCertificateKey = "/var/server.key";
    extraConfig = ''
      # Security / XSS Mitigation Headers
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-XSS-Protection "1; mode=block";
      add_header X-Content-Type-Options "nosniff";
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:2345/";
      extraConfig = ''
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
  networking.firewall.allowedTCPPorts = [ 2345 ];
}
