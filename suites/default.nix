{ lib }:
let
  inherit (builtins) mapAttrs isFunction;
  inherit (lib.flk) mkProfileAttrs profileMap;

  profiles = mkProfileAttrs (toString ../profiles);
  users = mkProfileAttrs (toString ../users);

  allProfiles =
    let defaults = lib.collect (x: x ? default) profiles;
    in map (x: x.default) defaults;

  allUsers =
    let defaults = lib.collect (x: x ? default) users;
    in map (x: x.default) defaults;


  suites = with profiles; rec {

    base = [
      core
      users.robots
      users.root
      users.jenkins
      networking.ssh
    ];

    basegui = [
      backups.syncthing
      filesystems.mount-nfs
    ];

    desktopStack = basegui ++ [
      desktop
      dev
      email.client
      backups.syncthing
    ];

    mailStack = [
      email.server
    ];

    mediaHost = [
      media.jellyfin
      media.rtorrent
      media.plex
    ];

    networkStack = [
      networking.unifi
    ];

    pipeline = [
      # cicd.jenkins ## dead meme for now
      cicd.gitea
    ];

    basedlan = mediaHost ++ pipeline ++ [
      media.rutorrent
      webserver.nginx
      security.bitwarden
      webserver.php
      docker.trilium
      home.assistant
      home.organizr
      home.searx
    ];

    nas = basedlan ++ [
      filesystems.export-nfs
      filesystems.export-smb
      filesystems.mount-zfs
      dev.binarycache.host
    ];

  };
in
mapAttrs (_: v: profileMap v) suites // {
  inherit allProfiles allUsers;
}
