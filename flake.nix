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

    in
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
        self = self';
      }
      (
        inputs.import-tree [
          ./flake # Core flake functionality
          ./hosts # Hardware based configurations
          ./modules # Nixos Modules
        ]
      );
}
