{ stdenv
, writeText
, php
, procps
, python39
, curl
, gzip
, coreutils
, ffmpeg
, mediainfo
, sox
, fetchFromGitHub
, srcs
, lib
}:
let 
    inherit (stdenv) mkDerivation;
    inherit (srcs) rutorrent;
    configFile = writeText "config.php" ''
    <?php
        // configuration parameters

        // for snoopy client
        @define('HTTP_USER_AGENT', 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0', true);
        @define('HTTP_TIME_OUT', 30, true);     // in seconds
        @define('HTTP_USE_GZIP', true, true);
        $httpIP = null;                         // IP string. Or null for any.

        @define('RPC_TIME_OUT', 5, true);       // in seconds

        @define('LOG_RPC_CALLS', false, true);
        @define('LOG_RPC_FAULTS', true, true);

        // for php
        @define('PHP_USE_GZIP', false, true);
        @define('PHP_GZIP_LEVEL', 2, true);

        $schedule_rand = 10;                    // rand for schedulers start, +0..X seconds

        $do_diagnostic = true;
        //$log_file = ;              // path to log file (comment or leave blank to disable logging)

        $saveUploadedTorrents = true;           // Save uploaded torrents to profile/torrents directory or not
        $overwriteUploadedTorrents = false;     // Overwrite existing uploaded torrents in profile/torrents directory or make unique name

        $topDirectory = '/';                    // Upper available directory. Absolute path with trail slash.
        $forbidUserSettings = false;

        // $scgi_port = 5000;
        // $scgi_host = "127.0.0.1";

        // For web->rtorrent link through unix domain socket
        // (scgi_local in rtorrent conf file), change variables
        // above to something like this:
        //
        //$scgi_port = 0;
        $scgi_host = "unix:////run/rtorrent/rpc.sock";

        $XMLRPCMountPoint = "/RPC2";            // DO NOT DELETE THIS LINE!!! DO NOT COMMENT THIS LINE!!!

        $pathToExternals = array(
            "php"   => '${php}/bin/php',
            "pgrep" => '${procps}/bin/pgrep',
            "python" => '${python39}/bin/python3',
            "curl"  => '${curl}/bin/curl',
            "gzip"  => '${gzip}/bin/gzip',
            "id"    => '${coreutils}/bin/id',
            "stat"  => '${coreutils}/bin/stat',
            "ffmpeg => '${ffmpeg}/bin/ffmpeg',
            "mediainfo => '${mediainfo}/bin/mediainfo',
            "sox" => '${sox}/bin/sox',
        );

        $localhosts = array(
            "127.0.0.1",
            "localhost",
        );

        $profilePath = '/mnt/private/nix-config-store/rutorrent/profiles';
        $profileMask = 0770;                    // Mask for files and directory creation in user profiles.
                                                // Both Webserver and rtorrent users must have read-write access to it.
                                                // For example, if Webserver and rtorrent users are in the same group then the value may be 0770.

        $tempDirectory = '/mnt/private/nix-config-store/rutorrent/profiles/tmp/';                     // Temp directory. Absolute path with trail slash. If null, then autodetect will be used.

        $canUseXSendFile = true;                // Use X-Sendfile feature if it exist

        $locale = "UTF8";
    '';
    version = lib.flk.mkVersion rutorrent;
in
    stdenv.mkDerivation rec {
        pname = "rutorrent";
        inherit version;

        src = rutorrent;

        installPhase = ''
            export HOME=".";
            mkdir $out;
            cp -r ./* $out/;
            cd $out;
            cp ${configFile} conf/config.php
        '';

        meta = with lib; {
            description = "Yet another web front-end for rTorrent";
            homepage = "https://github.com/Novik/ruTorrent";
            maintainers = [ maintainers.rpgwaiter ];
            license = licenses.gpl3Plus;
            platforms = platforms.all;
            inherit version;
        };
    }
