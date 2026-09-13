{
  flake.modules.nixos.ssh = { lib, ... }: {
    # SSH
    services.openssh = {
      enable = lib.mkDefault true;
      ports = [ 22 ];
      settings = {
        UseDns = true;
        PasswordAuthentication = false; # Disables password logins
        KbdInteractiveAuthentication = false; # Disables keyboard-interactive/PAM passwords
        PermitRootLogin = "prohibit-password"; # Prevents root login with passwords
      };
    };
  };
}
