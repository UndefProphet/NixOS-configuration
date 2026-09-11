{ lib, ... }: {
  flake.modules.nixos.testing-vm =
    { config, username, ... }:
    {

      config = {
        # Your normal machine configuration goes here (no autologin, no extra startup command)
        # environment.systemPackages = [ ... ];

        # This block ONLY triggers when built with 'build-vm'
        virtualisation.vmVariant = {
          # 1. Enable autologin inside the VM only
          services.getty.autologinUser = username;

          # 2. Run the command inside the VM only
          environment.loginShellInit = ''
            if [ "$(tty)" = "/dev/tty1" ]; then
              echo "Testing inside the build-vm environment..."
              start-hyprland
            fi
          '';
        };
      };

    };
}
