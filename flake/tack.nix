{ config, lib, ... }:
{
  config = {
    tack = {
      inputs.tack = "gh:manic-systems/tack";
      shorturls = {
        gh = "github:{path}";
      };
      all_follow = {
        nixpkgs = "nixpkgs";
      };
    };

    perSystem =
      {
        pkgs,
        inputs',
        ...
      }:
      let

        rootPath = ../.;

        tomlFormat = (pkgs.formats.toml { }).generate;
        serialisedInputs =
          (
            removeAttrs config.tack.inputs [
              "fetch"
              "fixed"
            ]
            |> lib.mapAttrs (
              _:
              {
                url,
                type,
                exclude_follow,
                follows,
                ...
              }:
              lib.filterAttrs (name: value: value != null && value != { } && value != [ ]) {
                inherit
                  url
                  type
                  follows
                  exclude_follow
                  ;
              }
            )
          )
          // (
            config.tack.inputs.fetch
            |> lib.mapAttrs (
              _: url: {
                inherit url;
                type = "fetch";
              }
            )
          )
          // (
            config.tack.inputs.fixed
            |> lib.mapAttrs (
              _: url: {
                inherit url;
                type = "fixed";
              }
            )
          );
        tackConfig = {
          inherit (config.tack) shorturls all_follow;
          inputs = serialisedInputs;
        };

        # Read the current state of pins.toml to diff against
        prevPins = lib.importTOML (rootPath + /inputs/pins.toml);

        # Inputs that need tack update: either new or URL-changed
        updateInputs =
          tackConfig.inputs
          |> lib.attrNames
          |> lib.filter (
            name: !(prevPins.inputs ? ${name}) || prevPins.inputs.${name}.url != tackConfig.inputs.${name}.url
          )
          |> lib.join " ";

        # Inputs that need to be removed: exist in prevPins but not in tackConfig
        removeInputs =
          (prevPins.inputs or { })
          |> lib.attrNames
          |> lib.filter (name: !(tackConfig.inputs ? ${name}))
          |> map (remKey: "tack rm ${remKey}")
          |> lib.concatLines;
      in
      let
        tackWrite = pkgs.writeShellApplication {
          name = "tack-write";
          derivationArgs = {
            allowSubstitutes = false;
            preferLocalBuild = true;
          };
          runtimeInputs = [
            pkgs.delta
            inputs'.tack.packages.tack
          ];
          text = # bash
            ''
              export TACK_DIR=./inputs/

              if [[ ! -f inputs/pins.toml ]]; then
                echo "Error: file not found: inputs/pins.toml" >&2
                exit 1
              fi

              ${lib.optionalString (prevPins != tackConfig) ''
                newPinsToml="${tackConfig |> tomlFormat "pins.toml"}"
                delta --dark --side-by-side --line-numbers --diff-so-fancy inputs/pins.toml "$newPinsToml" || true

                ${lib.optionalString (removeInputs != "") removeInputs}

                install -m 644 -D -T "$newPinsToml" inputs/pins.toml
                echo "wrote inputs/pins.toml"
              ''}
              # ${lib.optionalString (updateInputs != "") "tack update ${updateInputs}"}
            '';
        };
      in
      {
        packages.tack-write = tackWrite;
        apps.tack-write = {
          type = "app";
          meta.description = "Sync tack pins on input changes, can pass switch/boot/test arguments";
          program = lib.getExe tackWrite;
        };
      };
  };

  options.tack = lib.mkOption {
    description = "Tack input manager configuration.";
    default = { };
    type = lib.types.submodule {
      options = {
        shorturls = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
        };

        all_follow = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
        };

        inputs = lib.mkOption {
          default = { };
          type = lib.types.submodule {
            options = {
              fetch = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = "Shorthand for defining multiple fetch inputs";
              };
              fixed = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = "Shorthand for defining multiple fixed inputs";
              };
            };
            freeformType = lib.types.attrsOf (
              lib.types.coercedTo lib.types.str (url: { inherit url; }) (
                lib.types.submodule {
                  options = {
                    url = lib.mkOption {
                      type = lib.types.str;
                    };
                    type = lib.mkOption {
                      type = lib.types.nullOr (
                        lib.types.enum [
                          "fetch"
                          "fixed"
                        ]
                      );
                      default = null;
                    };
                    follows = lib.mkOption {
                      type = lib.types.attrsOf lib.types.str;
                      default = { };
                    };
                    exclude_follow = lib.mkOption {
                      type = lib.types.listOf lib.types.str;
                      default = [ ];
                    };
                  };
                }
              )
            );
          };
        };
      };
    };
  };
}
