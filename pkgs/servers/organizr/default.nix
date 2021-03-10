{ stdenv
, writeText
, php
, procps
, python39
, curl
, gzip
, coreutils
, fetchFromGitHub
, srcs
, lib
, ...
}:

let
  inherit (stdenv) mkDerivation;
  version = lib.flk.mkVersion srcs.organizr;
  src = srcs.organizr;
in

stdenv.mkDerivation rec {
  inherit version;
  inherit src;
  pname = "organizr";

  installPhase = ''
    export HOME=".";
    mkdir $out;
    cp -r ./* $out/;
    cd $out;
  '';

  meta = with lib; {
    description = "HTPC/Homelab Services Organizer - Written in PHP";
    homepage = "https://organizr.app";
    maintainers = [ maintainers.rpgwaiter ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    inherit version;
  };
}
