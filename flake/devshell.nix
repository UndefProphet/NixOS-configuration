{ self, ... }: {
  perSystem =
    {
      pkgs,
      lib,
      inputs',
      system,
      ...
    }:
    {

      formatter = pkgs.nixfmt-tree;

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nil
          sops
          inputs'.tack.packages.default
          self.packages.${system}.tack-write
        ];

        shellHook = ''
          export TACK_DIR=./inputs/
        '';
      };
    };
}
