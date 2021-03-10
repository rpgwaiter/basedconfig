{ ... }: {
  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    permitRootLogin = "no";
    passwordAuthentication = false;
    forwardX11 = true;
    openFirewall = true;
  };
}
