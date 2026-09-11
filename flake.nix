{
  description = "NixOS configuration";
  outputs =
    args@{ self, ... }:
    let

      # Tack as input manager with lazy evaluation
      inputs = (import ./inputs/tack.nix) { overrides = args.tackOverrides or { }; };
      self' = self // {
        inputs = inputs;
      }; # to make tack compatiable with flake-parts

      # flakeLib = (import ./flake/lib.nix) {
      #   inherit inputs;
      #   inherit (inputs.nixpkgs) lib;
      #   self = self';
      # };
      #
      # lib = inputs.nixpkgs.lib // flakeLib.config.flake.lib;

    in
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
        self = self';
        specialArgs = {
          # inherit lib;
        };
      }
      (
        inputs.import-tree [
          ./flake # Core flake functionality

          ./hosts # Hardware based configurations
          ./modules # Nixos Modules
          ./hjem # Hjem modules
        ]
      );
}
