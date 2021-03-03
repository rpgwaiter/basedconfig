{ config, ... }:
{
    imports = [ ../../users/storage ../webserver/php ];
    users.users.media = {
        isSystemUser = true;
        group = "storage";
    };
    services.phpfpm.pools.media = {
        user = "media";  
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
}