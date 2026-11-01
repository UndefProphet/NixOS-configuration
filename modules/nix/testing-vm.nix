{ lib, ... }: {
  flake.modules.nixos.testing-vm =
    { config, username, ... }:
    {

      config = {

        virtualisation.vmVariant = {

          services.getty.autologinUser = username;
          environment.loginShellInit = ''
            if [ "$(tty)" = "/dev/tty1" ]; then
              echo "Testing inside the build-vm environment..."
              # start-hyprland
            fi
          '';

          # The host key is shared into a system path; mounting it inside the
          # home directory would leave root-owned dirs there, breaking hjem.
          virtualisation.sharedDirectories.sops-age-keys = {
            source = "${config.hj.xdg.config.directory}/sops/age";
            target = "/var/lib/sops/age";
          };

          # User creation and sops secret decryption run in the initrd, so the
          # key share must be mounted there already.
          fileSystems."/var/lib/sops/age".neededForBoot = true;
          boot.initrd.availableKernelModules = [ "virtiofs" ];

          sops.age.keyFile = lib.mkForce "/var/lib/sops/age/keys.txt";

        };
      };

    };
}
