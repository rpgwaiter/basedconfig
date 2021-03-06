{ config, pkgs, ... }:
{
  nix.buildMachines = [{
    hostName = "nas";
    system = "x86_64-linux";
    sshUser = "robots";
    sshKey = toString ../../secrets/ssh/robots_id25519;
    # if the builder supports building for multiple architectures,
    # replace the previous line by, e.g.,
    # systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 1;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
