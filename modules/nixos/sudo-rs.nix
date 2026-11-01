{ lib, ... }: {
  flake.modules.nixos.sudo-rs =
    { config, ... }:
    {
      options.conf.system.sudo-rs.enable = lib.mkEnableOption {
        description = "Enable sudo replacement";
      };

      config =
        let
          cfg = config.conf.system.sudo-rs;
        in
        lib.mkIf cfg.enable {
          security = {
            sudo.enable = false;
            sudo-rs = {
              enable = true;
              wheelNeedsPassword = true;
              execWheelOnly = true;
              extraConfig = ''
                Defaults pwfeedback
              '';
            };
          };
        };
    };
}
