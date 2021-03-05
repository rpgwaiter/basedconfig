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

    networkStack = [
      networking.unifi
    ];
    
    mediaHost = [
      media.jellyfin
      media.rtorrent
      media.plex
    ];

    cicd = [
      cicd.jenkins
      cicd.gitea
    ];
    
    basedlan = mediaHost ++ cicd ++ [
      media.rutorrent
      webserver.nginx
    ];
    
    nas = base ++ [
      filesystems.export-nfs
      filesystems.export-smb
      filesystems.mount-zfs
    ];

  };
in
mapAttrs (_: v: profileMap v) suites // {
  inherit allProfiles allUsers;
}
