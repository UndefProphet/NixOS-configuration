{ self, ... }:
{
  perSystem = {
    packages.installer-iso = self.nixosConfigurations.installer-iso.config.system.build.isoImage;
  };

  flake.nixosConfigurations.installer-iso = {
    system = "x86_64-linux";
    stateVersion = "25.11";
    hostName = "nixos";
    username = "nixos";

    configuration =
      { pkgs, lib, ... }:
      {
        isoImage.squashfsCompression = "lz4";

        boot.kernelPackages = pkgs.linuxPackages_latest;
        # zfs is broken with the latest kernel; not needed on an installer ISO
        boot.supportedFilesystems.zfs = lib.mkForce false;

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];

        conf.networking.wifi.enable = true;

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

        # Enable SSH in the boot process
        systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
      };

    extraModules = [
      ({ modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
      })
    ];
  };
}
