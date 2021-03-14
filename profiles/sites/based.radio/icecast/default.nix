{ config, ... }:
{
  services.icecast = {
    enable = true;
    hostname = "cast.based.radio";
    listen.address = "192.168.69.111";
  };
}
