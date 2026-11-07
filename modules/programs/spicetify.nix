{
  lib,
  inputs,
  perSystem,
  ...
}:
{

  tack.inputs.spicetify = "gh:Gerg-L/spicetify-nix";

  flake.modules.nixos.spicetify =
    {
      inputs,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.conf.programs.spicetify;

      # Contains spicetify features
      spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.system};
    in
    {
      imports = [ inputs.spicetify.nixosModules.spicetify ];
      options.conf.programs.spicetify =
        with lib.types;
        with lib;
        {

          enable = mkEnableOption {
            description = "Enable spicetify";
          };

        };

      config = lib.mkIf cfg.enable {

        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.text;
        };

      };

    };
}
