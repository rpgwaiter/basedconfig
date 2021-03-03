{ config, ... }:
{
    users.users.jenkins = {
        extraGroups = [ "wheel" "docker" "storage" ];
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUmy/ud/EyNKqdiyfBcTRIzQ7aSNxAMjgt/gib6L9/4" ];
    };
    security.sudo.extraRules = [{ 
        users = [ "jenkins" ]; 
        commands = [ { command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; } ];
    }];
}