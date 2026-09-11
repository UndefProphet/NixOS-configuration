{ lib, ... }:
{
  flake.modules.hjem-modules.userDirs =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.xdg.userDirs;
    in
    {
      options.xdg.userDirs = lib.mkOption {
        description = ''
          XDG user directories. Every attribute other than `enable` and
          `create` sets the corresponding `XDG_<NAME>_DIR` environment
          variable, e.g. `screenshots = "$HOME/Pictures/Screenshots"` sets
          `XDG_SCREENSHOTS_DIR`.
        '';
        default = { };
        example = {
          enable = true;
          create = true;
          screenshots = "$HOME/Pictures/Screenshots";
        };

        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption {
              description = "Expose user directories as XDG environment variables.";
            };
            create = lib.mkEnableOption {
              description = "Create the configured directories.";
            };
          };
          freeformType = lib.types.attrsOf lib.types.str;
        };
      };

      config =
        let
          exlcudedEntries = [
            "enable"
            "create"
          ];
          directories = cfg |> lib.filterAttrs (name: value: !(lib.elem name exlcudedEntries));
        in
        lib.mkIf cfg.enable {

          # Generate the directories
          files =
            lib.mkIf cfg.create
            <| (
              directories
              |> lib.mapAttrs (
                name: value: {
                  type = "directory";
                  target = value;
                  clobber = false;
                }
              )
            );

          # Set eenvironment variables for the paths
          environment.sessionVariables =
            directories
            |> lib.mapAttrs' (
              name: value: {
                name = "XDG_${lib.toUpper name}_DIR";
                value = "${config.directory}/${value}";
              }
            );
        };
    };
}
