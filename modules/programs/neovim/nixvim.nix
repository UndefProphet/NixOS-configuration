{
  withSystem,
  inputs,
  lib,
  ...
}:
{

  tack.inputs.nixvim = "gh:nix-community/nixvim";

  flake.modules.nixos.neovim =
    {
      config,
      self',
      ...
    }:
    let
      cfg = config.conf.programs.neovim;
    in
    {
      options.conf.programs.neovim = {

        enable = lib.mkEnableOption {
          description = "Enable neovim.";
        };

        defaultEditor = lib.mkEnableOption {
          description = "Set as default terminal editor.";
          default = true;
        };

      };

      config = lib.mkIf cfg.enable {
        hj.packages = [
          self'.packages.neovim
        ];

        hj.environment.sessionVariables = lib.mkIf cfg.defaultEditor {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };
    };

  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      inherit (inputs.nixvim.lib) evalNixvim;
      nixvim = evalNixvim {
        inherit system;
        modules = [
          (inputs.import-tree ./_modules)
          { nixpkgs.source = inputs.nixpkgs; }
        ];
      };
    in
    {
      checks.neovim = nixvim.config.build.test;
      packages.neovim = nixvim.config.build.package;

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
