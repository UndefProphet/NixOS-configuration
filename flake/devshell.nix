{ ... }: {
  perSystem =
    {
      pkgs,
      inputs',
      self',
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
          inputs'.hjem.packages.hjem
        ];

        shellHook = ''
          export TACK_DIR=./inputs/
          alias tack-write="${self'.apps.tack-write.program}"
        '';
      };
    };
}
