{ config, ... }:
{
    services.phpfpm.phpOptions = ''
        memory_limit = 8G
        upload_max_filesize = 24M
        post_max_size = 32M    
    '';
}