{ config, ... }:
{
  services.grocy = {
    enable = true;
    hostName = "food.based.lan";
  };
}
