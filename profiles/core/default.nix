{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  nix.package = pkgs.nixFlakes;

  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  time.timeZone = "America/Chicago";

  environment = {

    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      deploy-rs
      direnv
      dnsutils
      dosfstools
      fd
      git
      git-crypt
      gotop
      gptfdisk
      iputils
      jq
      moreutils
      nix-index
      nmap
      ripgrep
      tealdeer
      tmux
      utillinux
      whois
    ];

    # shellInit = ''
    #   export STARSHIP_CONFIG=${
    #     pkgs.writeText "starship.toml"
    #     (fileContents ./starship.toml)
    #   }
    # '';

    shellInit = ''
      function extract {
        if [ -z "$1" ]; then
            # display usage if no parameters given
            echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        else
            if [ -f $1 ] ; then
                # NAME=''${1%.*}
                # mkdir $NAME && cd $NAME
                case $1 in
                  *.tar.bz2)   tar xvjf ./$1    ;;
                  *.tar.gz)    tar xvzf ./$1    ;;
                  *.tar.xz)    tar xvJf ./$1    ;;
                  *.lzma)      unlzma ./$1      ;;
                  *.bz2)       bunzip2 ./$1     ;;
                  *.rar)       unrar x -ad ./$1 ;;
                  *.gz)        gunzip ./$1      ;;
                  *.tar)       tar xvf ./$1     ;;
                  *.tbz2)      tar xvjf ./$1    ;;
                  *.tgz)       tar xvzf ./$1    ;;
                  *.zip)       unzip ./$1       ;;
                  *.Z)         uncompress ./$1  ;;
                  *.7z)        7z x ./$1        ;;
                  *.xz)        unxz ./$1        ;;
                  *.exe)       cabextract ./$1  ;;
                  *)           echo "extract: '$1' - unknown archive method" ;;
                esac
            else
                echo "$1 - file does not exist"
            fi
        fi
      }
    '';

    shellAliases =
      let ifSudo = lib.mkIf config.security.sudo.enable;
      in
      {
        # fix nixos-option
        nixos-option = "nixos-option -I nixpkgs=${toString ../../compat}";

        top = "gotop";
        myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";
        cp = "rsync -avz --progress";
        dcu = "sudo docker-compose up -d";
        s = "sudo systemctl";
        mkdir = "mkdir -p";
        conf = "cd ~/git/basedconfig-ng";
        nas = "ssh nas";
        dc = "sudo docker-compose";
        pull = "git pull";
      };
  };

  fonts = {
    fonts = with pkgs; [ powerline-fonts dejavu_fonts ubuntu_font_family ];

    fontconfig.defaultFonts = {

      monospace = [ "Ubuntu Mono" ];

      sansSerif = [ "Ubuntu Regular" ];

    };
  };

  nix = {

    autoOptimiseStore = true;

    gc.automatic = true;

    optimise.automatic = true;

    useSandbox = true;

    allowedUsers = [ "@wheel" ];

    trustedUsers = [ "root" "@wheel" ];

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';

  };

  programs.fish = {
    enable = true;
    # promptInit = ''
    #   eval "(${pkgs.starship}/bin/starship init fish)"
    # '';
    # shellInit = ''
    #   eval "(${pkgs.direnv}/bin/direnv hook fish)"
    # '';
  };

  services.earlyoom.enable = true;

  users.mutableUsers = false;

}
