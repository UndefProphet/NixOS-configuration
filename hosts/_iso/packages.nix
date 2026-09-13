{ self, ... }: {
  flake.modules.nixos.iso = { pkgs, ... }: {
    imports = [ ];

    isoImage.squashfsCompression = "lz4";

    environment.systemPackages = [
      self.packages.x86_64-linux.neovim
      pkgs.yazi
    ];

    nix = {
      optimise.automatic = true;
      settings = {
        max-jobs = "auto"; # how many builds at once
        cores = 0; # cores per build (0 = all available)
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    # Enable SSH in the boot process.j
    systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false; # Disables password logins
        KbdInteractiveAuthentication = false; # Disables keyboard-interactive/PAM passwords
        PermitRootLogin = "prohibit-password"; # Prevents root login with passwords
      };
    };
    users.users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMogwr9yqxa3C2pzi8uUmTFRTnXVW5bNdK8h8mm08oWI boink"
      ];
    };
    users.users.nixos = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMogwr9yqxa3C2pzi8uUmTFRTnXVW5bNdK8h8mm08oWI boink"
      ];
    };
  };
}
