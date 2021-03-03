{ pkgs, ... }:
{
    users = {
        users.storage = {
            isSystemUser = true;
            home = "/mnt/private";
            group = "storage";
        };
        groups.storage = { members = [ "storage" ]; };
    };
}