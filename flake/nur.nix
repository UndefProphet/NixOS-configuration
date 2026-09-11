{ inputs, lib, ... }: {
  tack.inputs.nur = "gh:nix-community/NUR?ref=master";

  flake.modules.nixos.nur = {
    imports = [
      {
        options.conf.system.nur = {
          enable = lib.mkEnableOption {
            default = false;
            description = "Enable NUR";
          };
        };
      }
      # NUR only exposes the `nur` package repo, so it is imported
      # unconditionally; conditional imports based on `config` would cause
      # infinite recursion in the module system.
      inputs.nur.modules.nixos.default
    ];
  };
}
