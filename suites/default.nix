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
    /*
    base = [ users.nixos users.root ];
    */
    
    base = [
      users.robots
      users.root
      users.jenkins
      networking.ssh
    ];

    basegui = [
      backups.syncthing
      filesystems.mount-nfs
    ];

    # Desktop
    desktopStack = basegui ++ [
      desktop
      email.client
    ];

    # Servers
    networkStack = with networking; [
      unifi
    ];
    
    mediaHost = with media; [ 
      jellyfin
      rtorrent
      plex
    ];

    cicd = with cicd; [
      jenkins
      gitea
    ];
    
    basedlan = mediaHost ++ cicd ++ [
      media.rutorrent
      webserver.nginx
    ];
    
    nas = with filesystems; [
      export-nfs
      export-smb
      mount-zfs
    ];

  };
in
mapAttrs (_: v: profileMap v) suites // {
  inherit allProfiles allUsers;
}
