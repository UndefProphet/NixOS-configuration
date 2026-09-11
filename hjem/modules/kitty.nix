{ lib, ... }: {
  flake.modules.hjem-modules.kitty =
    { config, pkgs, ... }:
    let
      cfg = config.programs.kitty;
    in
    {
      options.programs.kitty = {

        enable = lib.mkEnableOption {
          description = "Enable kitty";
        };

        package = lib.mkPackageOption pkgs "kitty" {
          nullable = true;
          extraDescription = "Set this to null if you use the Hjem module to install kitty.";
        };

      };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];
      };
    };
}
