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

      devShells.default =
        let

          # Allows for editing sops files from root of project
          # Required to have SOPS_TARGET_DIR and SOPS_CONFIG set.
          # Example: sops github.yaml
          sopsModuleDirectoryDefault = pkgs.writeShellScriptBin "sops" ''
            file_path=""
            remaining_args=()

            for arg in "$@"; do
              if [[ -z "$file_path" && ! "$arg" == -* ]]; then
                file_path="$arg"
              else
                remaining_args+=("$arg")
              fi
            done

            if [[ "$file_path" != */* ]]; then
              file_path="''${SOPS_TARGET_DIR%/}/$file_path"
            fi

            exec ${pkgs.sops}/bin/sops \
              --config "$SOPS_CONFIG" \
              "''${remaining_args[@]}" \
              "$file_path"
          '';

        in
        pkgs.mkShell {
          packages = with pkgs; [
            nixd
            nil
            sops
            inputs'.tack.packages.default
            inputs'.hjem.packages.hjem
          ];

          # Environment variables
          TACK_DIR = "./inputs/";
          SOPS_CONFIG = "./modules/secrets/sops.yaml";
          SOPS_TARGET_DIR = "./modules/secrets";

          shellHook = # bash
            ''
              alias tack-write="${self'.apps.tack-write.program}"
              alias sops="${sopsModuleDirectoryDefault}/bin/sops"
            '';
        };
    };
}
