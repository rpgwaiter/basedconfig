{ config, ... }:
{
    networking.firewall.allowedTCPPorts = [ 2049 ];
    services.samba = {
        enable = true;
        securityType = "user";
        extraConfig = ''
        workgroup = WORKGROUP
        server string = nixos-storage
        netbios name = nixos-storage
        security = user 
        #use sendfile = yes
        #max protocol = smb2
        hosts allow = 192.168.69.0/24  localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
        '';
        shares = {
            public = {
                path = "/mnt/public";
                browseable = "yes";
                "read only" = "no";
                "guest ok" = "yes";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = "robots";
                "force group" = "users";
            };
            private = {
                path = "/mnt/private";
                browseable = "yes";
                "read only" = "no";
                "guest ok" = "no";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = "robots";
                "force group" = "users";
            };
        };
    };
}