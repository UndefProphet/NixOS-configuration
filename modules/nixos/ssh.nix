{ lib, ... }: {
  flake.modules.nixos.ssh =
    { config, ... }:
    {
      options.conf.networking.ssh = {
        enable = lib.mkEnableOption {
          description = "Enable ssh.";
        };

        enableAgent = lib.mkEnableOption {
          description = "Enable agent for remembering private keys.";
        };

        enableServer = lib.mkEnableOption {
          description = "Enable ssh access to this machine.";
        };
      };

      config =
        let
          cfg = config.conf.networking.ssh;
        in

        lib.mkIf cfg.enable (
          lib.mkMerge [
            (lib.mkIf cfg.enableAgent { programs.ssh.startAgent = true; })

            (lib.mkIf cfg.enableServer {
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
            })
          ]
        );
    };
}
