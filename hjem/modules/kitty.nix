{ lib, ... }: {
  flake.modules.hjem-modules.kitty =
    { config, pkgs, ... }:
    let
      cfg = config.programs.kitty;
    in
    {
      options.programs.kitty =
        with lib.types;
        with lib;
        {

          enable = mkEnableOption {
            description = "Enable kitty";
          };

          package = mkPackageOption pkgs "kitty" {
            extraDescription = "Set this to null if you use the Hjem module to install kitty.";
            nullable = true;
          };

          settings = lib.mkOption {
            description = "Configuration settings.";
            type = lib.types.attrsOf (
              lib.types.oneOf [
                lib.types.str
                lib.types.int
                lib.types.float
                lib.types.bool
              ]
            );
            default = { };
          };

        };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];

        xdg.config.files."kitty/kitty.conf".text = lib.concatStringsSep "\n" [
          ''
            # See https://sw.kovidgoyal.net/kitty/conf.html
          ''
          (
            cfg.settings
            |> lib.generators.toKeyValue {
              mkKeyValue =
                key: value:
                "${key} ${if builtins.isBool value then (if value then "yes" else "no") else toString value}";
            }
          )
        ];
      };
    };
}
