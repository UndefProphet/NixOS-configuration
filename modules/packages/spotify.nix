{ inputs, lib, ... }: {
  # https://github.com/Gerg-L/spicetify-nix
  # A themebale spotify client
  tack.inputs.spicetify-nix = "gh:Gerg-L/spicetify-nix?ref=master";

  flake.modules.nixos.spotify =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.conf.packages.spotify;
    in
    {
      options.conf.packages.spotify.enable = lib.mkEnableOption {
        description = "Enable spotify";
      };

      config = lib.mkIf cfg.enable {
        hm = {
          imports = [
            inputs.spicetify-nix.homeManagerModules.spicetify
          ];

          programs = {
            spicetify =
              let
                spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
              in
              {
                enable = true;
                # theme = spicePkgs.themes.text // { };
              };
          };
        };
      };
    };
}
