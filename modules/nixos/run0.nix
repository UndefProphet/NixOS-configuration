{ lib, ... }: {
  flake.modules.nixos.sudo-rs =
    { config, ... }:
    {
      options.conf.system.run0.enable = lib.mkEnableOption {
        description = "Enable run0 replacement";
      };

      config =
        let
          cfg = config.conf.system.run0;
        in
        lib.mkIf cfg.enable {
          security = {
            sudo.enable = false;
            run0 = {
              enable = true;
              sudo-shim.enable = true;
              persistentAuth.enable = true;
            };
            polkit = {
              enable = true;
              settings.Polkitd.ExpirationSeconds = 60;
            };
          };
        };
    };
}
