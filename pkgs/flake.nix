{
  description = "Package sources";

  inputs = {
    rutorrent.url = "github:Novik/rutorrent";
    rutorrent.flake = false;

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = { ... }: { };
}
