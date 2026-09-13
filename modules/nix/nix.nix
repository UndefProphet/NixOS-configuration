{
  # Nix packages
  # A collection of over 100,000 software packages that can be installed with the Nix.
  tack.inputs.nixpkgs = "gh:nixos/nixpkgs?ref=nixos-unstable";

  flake.modules.nixos.nix =
    {
      config,
      lib,
      stateVersion,
      ...
    }:

    let
      cfg = config.conf.system.nix;
    in
    {
      options.conf.system.nix = {
        enable = lib.mkEnableOption {
          default = false;
          description = "Enable nix configuration";
        };
      };

      config = {
        system = { inherit stateVersion; };
        nix = {
          optimise.automatic = true;
          settings = {
            max-jobs = "auto"; # how many builds at once
            cores = 0; # cores per build (0 = all available)
            auto-optimise-store = true;
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];
          };
        };

        # Packages
        nixpkgs.config.allowBroken = false;
        nixpkgs.config.allowUnfree = true;
        environment.variables = {
          NIXPKGS_ALLOW_UNFREE = 1;
        }; # For nix-shell and other commands
      };
    };
}
