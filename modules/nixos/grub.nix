{ lib, ... }: {

  flake.modules.nixos.grub =
    { config, ... }:
    let
      cfg = config.conf.boot.grub;
    in
    {

      options.conf.boot.grub = {

        enable = lib.mkEnableOption {
          default = false;
          description = "Enable grub bootloader";
        };

      };

      config = lib.mkIf cfg.enable {

        boot.loader = {
          grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            efiInstallAsRemovable = true;
            useOSProber = true;
            gfxmodeEfi = lib.mkDefault "3440x1440";
            gfxmodeBios = lib.mkDefault "3440x1440";
            splashMode = "normal";
          };
        };
      };

    };
}
