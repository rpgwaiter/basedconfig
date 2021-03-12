{ config, ... }:
{
  services.grocy = {
    enable = true;
    hostName = "food.based.lan";
    nginx.enableSSL = false;
  };
}
