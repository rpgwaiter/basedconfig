   { config, pkgs, ... }:
   let release = "master";
   in {
       imports = [
            (builtins.fetchTarball {
            # Pick a commit from the branch you are interested in
            url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz";
            # And set its hash
            sha256 = "1m8ylrxlkn8nrpsvnivg32ncba9jkfal8a9sjy840hpl1jlm5lc4";
            })
        ];
            services.nginx = {
                enable = true;
                virtualHosts."mail.based.zone" = {
                    enableACME = true;
                    forceSSL = true;
                    locations."/" = {
                        extraConfig = ''
                            root /home/robots/sink;
                        '';
                    };
                };
            };
            security.acme = {
                email = "rpgwaiter@based.zone";
                acceptTerms = true;
                certs = {
                    "mail.based.zone".email = "rpgwaiter@based.zone";
                };
            };
    #  modules = [
        # simple-nixos-mailserver.nixosModule
        # {
            mailserver = {
                enable = true;
                fqdn = "mail.based.zone";
                domains = [ "based.zone" "based.radio" "faggot.today" ];
                loginAccounts = {
                    "robots@based.zone" = {
                        # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2 > /hashed/password/file/location
                        hashedPasswordFile = "/private/emailhash";

                        aliases = [
                            "info@based.zone"
                            "postmaster@based.zone"
                            "rpgwaiter@based.zone"
                        ];

                        catchAll = [
                            "based.zone"
                            "based.radio"
                        ];
                    };
                };
                # Use Let's Encrypt certificates. Note that this needs to set up a stripped
                # down nginx and opens port 80.
                certificateScheme = 3;

                # Enable IMAP and POP3
                enableImap = true;
                enablePop3 = true;
                enableImapSsl = true;
                enablePop3Ssl = true;

                # Enable the ManageSieve protocol
                enableManageSieve = true;

                # whether to scan inbound emails for viruses (note that this requires at least
                # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
                virusScanning = false;
            };
            environment.systemPackages = with pkgs; [
                lego
            ];
   }
#         }
#     # ];
#    }

