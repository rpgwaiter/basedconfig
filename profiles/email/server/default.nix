{ config, pkgs, ... }:
{
  imports = let ver = "7627c29268d2f49ede330a806524447ad9cf9c3f"; in
    [
      (builtins.fetchTarball {
        # Pick a commit from the branch you are interested in
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${ver}/nixos-mailserver-${ver}.tar.gz";
        # And set its hash
        sha256 = "";
      })
    ];


  mailserver = {
    enable = true;
    fqdn = "nixos-external.noticesbul.ge";
    domains = [ "noticesbul.ge" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "owo@noticesbul.ge" = {
        hashedPassword = "$2y$05$Oo97aO38IVsXrvhe78/H8uRmRHXxQXBsLHb8s7hq8Wp5T2IiDvtOe";

        aliases = [
          "postmaster@noticesbul.ge"
        ];

        # Make this user the catchAll address for domains example.com and
        # example2.com
        catchAll = [
          "noticesbul.ge"
        ];
      };
    };

    # Extra virtual aliases. These are email addresses that are forwarded to
    # loginAccounts addresses.
    # extraVirtualAliases = {
    #     # address = forward address;
    #     "abuse@example.com" = "user1@example.com";
    # };

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
}
