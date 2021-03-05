{ config, pkgs, ... }:
{
  imports = [ ../php ];
  security.acme = { email = "rpgwaiter@based.zone"; acceptTerms = true; };
  services.phpfpm.pools.www = {
    user = "nginx"; 
    group = "storage";                                                                                                                                                                                                                       
    settings = {                                                                                                                                                                                                                               
      pm = "dynamic";            
      "listen.owner" = config.services.nginx.user;                                                                                                                                                                                                              
      "pm.max_children" = 5;                                                                                                                                                                                                                   
      "pm.start_servers" = 2;                                                                                                                                                                                                                  
      "pm.min_spare_servers" = 1;                                                                                                                                                                                                              
      "pm.max_spare_servers" = 3;                                                                                                                                                                                                              
      "pm.max_requests" = 1000;                                                                                                                                                                                                    
    };   
  };
  services.nginx = {
      package = pkgs.nginxMainline;
      enable = true;
      user = "nginx";
      group = "storage";
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      clientMaxBodySize = "100m";
      commonHttpConfig = ''
          map $scheme $hsts_header {
              https   "max-age=31536000; includeSubdomains; preload";
          }
          add_header Strict-Transport-Security $hsts_header;
          add_header 'Referrer-Policy' 'origin-when-cross-origin';
          add_header X-Frame-Options DENY;
          add_header X-Content-Type-Options nosniff;
          add_header X-XSS-Protection "1; mode=block";
        '';

      virtualHosts = let 
        proxyBlock = port: {
          # addSSL = true;
          extraConfig = ''
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Content-Type-Options "nosniff";
          '';
          locations."/" = {
            extraConfig = ''
              proxy_pass http://127.0.0.1:${toString port};
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Protocol $scheme;
              proxy_set_header X-Forwarded-Host $http_host;
              proxy_buffering off;
            '';
          };
        }; 
        in
        {
        "sync.based.lan" = proxyBlock 8384;
        "food.based.lan" = proxyBlock 8000;
        "money.based.lan" = proxyBlock 3338;
        #"grafana.based.lan" = proxyBlock 2342 // rec { proxyWebsockets = true; };
        # "files.based.zone" = { 
        #   addSSL = true;
        #   enableACME = true;
        #   extraConfig = ''
        #     location / {
        #       proxy_pass http://localhost:22504;
        #     }
        #     location ^~ /vault/ {
        #       root /srv;
        #     }
        #     # location ~ \.php$ {
        #     #   fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
        #     # }
        #   '';
        # };
      };
    };
    # mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    #   ensureUsers = [
    #     { name = "laravel"; ensurePermissions = { "*" = "ALL PRIVILEGES"; }; }
    #   ];
    # };
}