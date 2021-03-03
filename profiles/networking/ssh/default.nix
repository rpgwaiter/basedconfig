{ ... }: {
  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    permitRootLogin = "no";
    passwordAuthentication = true;
    forwardX11 = true;
    openFirewall = true;
  };
}