{ config, pkgs, ... }:
{
  services.jenkins = {
    enable = true;
    port = 8811;
    listenAddress = "192.168.69.111";
    environment = {
      "user.timezone" = "America/Central";
    };
    packages = with pkgs; [
      direnv
      nix-shell
      git
      stdenv
      config.programs.ssh.package
      nix
      bashInteractive
      sudo
      docker
      wget
      curl
      screen
    ];
  };

  networking.firewall.allowedTCPPorts = [ 8811 ];
  services.nginx.upstreams.jenkins.extraConfig = ''
    keepalive 32;
    server 127.0.0.1:8811;
  '';
  # services.nginx.appendConfig = ''
  #     map $http_upgrade $connection_upgrade {
  #     default upgrade;
  #     '''' close;
  #     }
  # '';
  services.nginx.virtualHosts."jenkins.based.lan" = {
    addSSL = true;
    sslCertificate = "/var/server.crt";
    sslCertificateKey = "/var/server.key";

    locations."/userContent".extraConfig = ''
      # have nginx handle all the static requests to userContent folder
      # note : This is the $JENKINS_HOME dir
      root /var/lib/jenkins/;
      if (!-f $request_filename){
          # this file does not exist, might be a directory or a /**view** url
          rewrite (.*) /$1 last;
          break;
      }
      sendfile on;
    '';
    locations."/".extraConfig = ''
      sendfile off;
      proxy_pass         http://jenkins;
      proxy_redirect     default;
      proxy_http_version 1.1;

      # Required for Jenkins websocket agents
      proxy_set_header   Connection        $connection_upgrade;
      proxy_set_header   Upgrade           $http_upgrade;

      proxy_set_header   Host              $host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;

      #this is the maximum upload size
      client_max_body_size       10m;
      client_body_buffer_size    128k;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_buffering            off;
      proxy_request_buffering    off; # Required for HTTP CLI commands
      proxy_set_header Connection ""; # Clear for keepalive
    '';
  };
}
