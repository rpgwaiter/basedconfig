{
  description = "Package sources";

  inputs = {
    rutorrent.url = "github:Novik/rutorrent";
    rutorrent.flake = false;

    organizr.url = "github:causefx/Organizr";
    organizr.flake = false;

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = { ... }: { };
}
