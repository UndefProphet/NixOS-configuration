{
  # https://github.com/nix-community/disko
  # Disc partitioning and declaration
  tack.inputs.disko = "gh:nix-community/disko?ref=master";

  flake.modules.nixos.disko =
    { inputs, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];
    };
}
