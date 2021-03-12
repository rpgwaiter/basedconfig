{ config, ... }:
{
  services.grocy = {
    enable = true;
    hostName = "food.based.lan";
    nginx.enableSSL = false;
  };

  services.nginx.virtualHosts."food.based.lan" = {
    addSSL = true;
    sslCertificate = "/var/server.crt";
    sslCertificateKey = "/var/server.key";
  };
}
