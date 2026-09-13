{ inputs, lib, ... }: {
  # https://github.com/nix-community/nix-index
  # A files database for nixpkgs
  tack.inputs.nix-index-database = "gh:nix-community/nix-index-database?ref=main";

  flake.modules.nixos.comma =
    { config, ... }:
    let
      cfg = config.conf.packages.comma;
    in
    {
      options.conf.packages.comma.enable = lib.mkEnableOption {
        description = "Enable comma";
      };

      config = lib.mkIf cfg.enable {
        hm = {
          imports = [ inputs.nix-index-database.homeModules.default ];
          programs.nix-index-database.comma.enable = true;
        };
      };
    };
}
