{ inputs, ... }:
let
  nixvim = inputs.nixvim;
  configPath = ./_config;
in
{
  # https://github.com/nix-community/nixvim
  # Neovim configuration
  tack.inputs.nixvim = "gh:nix-community/nixvim";

  flake = {
    nixvimModule = import configPath;

    modules.nixos.neovim =
      {
        config,
        lib,
        ...
      }:
      let
        cfg = config.conf.packages.neovim;
      in
      {
        options.conf.packages.neovim.enable = lib.mkEnableOption {
          description = "Enable neovim";
        };

        config = lib.mkIf cfg.enable {
          hm = {
            imports = [
              nixvim.homeModules.nixvim
              {
                programs.nixvim.enable = true;
              }
            ];
            programs.nixvim = import configPath;
          };
        };
      };
  };

  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    let
      nixvimLib = nixvim.lib.${system};
      nixvim' = nixvim.legacyPackages.${system};
      nixvimModule = {
        inherit system;
        module = import configPath;
        extraSpecialArgs = { };
      };
      nvim = nixvim'.makeNixvimWithModule nixvimModule;
    in
    {
      checks = {
        default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
      };

      packages = {
        neovim = nvim;
      };

      devShells.neovim = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nil
          lua
        ];

        shellHook = ''
          cd modules/packages/neovim
        '';
      };
    };
}
