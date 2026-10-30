{ lib, ... }:
{
  flake.modules.hjem-modules.fish =
    { config, pkgs, ... }:
    let
      cfg = config.programs.fish;

      abbrModule = lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "The abbreviation name that is replaced by the expansion. Defaults to the attribute name.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          expansion = lib.mkOption {
            description = "The command expanded by an abbreviation.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          position = lib.mkOption {
            description = ''
              If the position is "command", the abbreviation expands only if
              the position is a command. If it is "anywhere", the abbreviation
              expands anywhere.
            '';
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "anywhere";
          };

          regex = lib.mkOption {
            description = "The regular expression pattern matched instead of the literal name.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          command = lib.mkOption {
            description = ''
              The command(s) for which the abbreviation should expand. If set,
              the abbreviation will only expand when used as an argument to
              the given command(s).
            '';
            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
            default = null;
          };

          setCursor = lib.mkOption {
            description = ''
              The marker indicates the position of the cursor when the
              abbreviation is expanded. When set to true, the marker defaults
              to "%".
            '';
            type = lib.types.either lib.types.bool lib.types.str;
            default = false;
          };

          function = lib.mkOption {
            description = "The fish function expanded instead of a literal string.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      };

      functionModule = lib.types.submodule {
        options = {
          body = lib.mkOption {
            description = "The function body.";
            type = lib.types.lines;
          };

          argumentNames = lib.mkOption {
            description = "Assigns the value of successive command line arguments to the names given.";
            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
            default = null;
          };

          description = lib.mkOption {
            description = "A description of what the function does, suitable as a completion description.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          wraps = lib.mkOption {
            description = "Causes the function to inherit completions from the given wrapped command.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          onEvent = lib.mkOption {
            description = "Tells fish to run this function when the specified named event is emitted.";
            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
            default = null;
          };

          onVariable = lib.mkOption {
            description = "Tells fish to run this function when the specified variable changes value.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          onSignal = lib.mkOption {
            description = "Tells fish to run this function when the specified signal is delivered.";
            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
            default = null;
          };

          noScopeShadowing = lib.mkOption {
            description = "Allows the function to access the variables of calling functions.";
            type = lib.types.bool;
            default = false;
          };

          inheritVariable = lib.mkOption {
            description = ''
              Snapshots the value of the specified variable and defines a
              local variable with that same name and value when the function
              is defined.
            '';
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      };

      completionModule = lib.types.submodule {
        options = {
          body = lib.mkOption {
            description = "The completion file's body.";
            type = lib.types.lines;
          };
        };
      };

      pluginModule = lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "The name of the plugin.";
            type = lib.types.str;
          };

          src = lib.mkOption {
            description = ''
              Path to the plugin folder. Relevant pieces will be added to the
              fish function path and the completion path. The `init.fish` and
              `key_bindings.fish` files are sourced if they exist.
            '';
            type = lib.types.path;
          };
        };
      };

      bindModule = lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "The key name that is used for the bind. Defaults to the attribute name.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          enable = lib.mkEnableOption {
            description = "Enable the bind. Set to false to ignore the bind.";
            default = true;
          };

          mode = lib.mkOption {
            description = "The bind mode that the bind is used in.";
            type = lib.types.nullOr (
              lib.types.either (lib.types.enum [
                "default"
                "insert"
                "paste"
              ]) lib.types.str
            );
            default = null;
          };

          command = lib.mkOption {
            description = "The command that will be executed.";
            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
            default = null;
          };

          setsMode = lib.mkOption {
            description = "Change the current mode after the bind is executed.";
            type = lib.types.nullOr (
              lib.types.either (lib.types.enum [
                "default"
                "insert"
                "paste"
              ]) lib.types.str
            );
            default = null;
          };

          erase = lib.mkEnableOption {
            description = "Remove the bind.";
          };

          silent = lib.mkEnableOption {
            description = "Operate silently.";
          };

          repaint = lib.mkEnableOption {
            description = "Redraw the prompt after the command.";
          };

          operate = lib.mkOption {
            description = "Operate on preset bindings or user bindings.";
            type = lib.types.nullOr (
              lib.types.enum [
                "preset"
                "user"
              ]
            );
            default = null;
          };
        };
      };

      # Translate hjem session variables into fish with babelfish.
      sessionVars = pkgs.runCommandLocal "fish-session-vars.fish" { } ''
        (echo "function setup_hjem_session_vars;"
        ${pkgs.buildPackages.babelfish}/bin/babelfish <${config.environment.loadEnv}
        echo "end"
        echo "setup_hjem_session_vars") > $out
      '';

      filteredBinds = cfg.binds |> lib.filterAttrs (_: value: value.enable);

      bindsStr =
        filteredBinds
        |> lib.mapAttrsToList (
          k:
          {
            name,
            silent,
            erase,
            repaint,
            operate,
            mode,
            setsMode,
            command,
            ...
          }:
          let
            key = if name != null then name else k;
            opts =
              lib.optionals silent [ "-s" ]
              ++ lib.optionals (operate != null) [ "--${operate}" ]
              ++ lib.optionals (mode != null) [
                "--mode"
                mode
              ]
              ++ lib.optionals (setsMode != null) [
                "--sets-mode"
                setsMode
              ];
            cmdNormal = lib.concatStringsSep " " (
              [ "bind" ]
              ++ opts
              ++ [ key ]
              ++ map lib.escapeShellArg (lib.flatten [ command ])
              ++ lib.optionals repaint "repaint"
            );
            cmdErase = lib.concatStringsSep "  " (
              [
                "bind"
                "-e"
              ]
              ++ opts
              ++ [ key ]
            );
          in
          lib.optionals erase [ cmdErase ] ++ lib.optionals (command != null) [ cmdNormal ]
        )
        |> lib.flatten
        |> lib.concatStringsSep "\n";

      abbrsStr =
        cfg.shellAbbrs
        |> lib.mapAttrsToList (
          name: def:
          let
            isSubmodule = builtins.isAttrs def;
            abbrName = if isSubmodule && def.name != null then def.name else name;
            modifiers =
              if !isSubmodule then
                ""
              else
                lib.cli.toCommandLineShell
                  (optionName: {
                    option = "--${optionName}";
                    sep = if optionName == "set-cursor" then "=" else null;
                    explicitBool = false;
                    formatArg = lib.generators.mkValueStringDefault { };
                  })
                  {
                    inherit (def)
                      position
                      regex
                      command
                      function
                      ;
                    set-cursor = def.setCursor;
                  };
            expansion = if isSubmodule then def.expansion else def;
          in
          "abbr --add ${modifiers} -- ${abbrName}"
          + lib.optionalString (expansion != null) " ${lib.escapeShellArg expansion}"
        )
        |> lib.join "\n";

      aliasesStr =
        cfg.shellAliases
        |> lib.mapAttrsToList (name: value: "alias ${name} ${lib.escapeShellArg value}")
        |> lib.join "\n";

      # Functions triggered by events must be sourced from config.fish
      # before the events are emitted.
      sourceHandlersStr =
        let
          handlerAttrs = [
            "onVariable"
            "onSignal"
            "onEvent"
          ];
          isHandler = _: def: builtins.isAttrs def && (handlerAttrs |> lib.any (attr: def.${attr} != null));
          functionsDir = "${config.xdg.config.directory}/fish/functions";
        in
        cfg.functions
        |> lib.filterAttrs isHandler
        |> lib.mapAttrsToList (name: _: "source ${functionsDir}/${name}.fish")
        |> lib.join "\n";

      functionFiles =
        cfg.functions
        |> lib.mapAttrs' (
          name: def:
          let
            isSubmodule = builtins.isAttrs def;
            body = if isSubmodule then lib.removeSuffix "\n" def.body else def;
            quoted = flag: value: lib.optional (value != null) ''--${flag}="${toString value}"'';
            boolFlag = flag: value: lib.optional (value == true) "--${flag}";
            onEventFlags =
              def.onEvent
              |> lib.toList
              |> lib.filter (value: value != null)
              |> map (value: ''--on-event="${value}"'');
            argumentFlags =
              if def.argumentNames == null then
                [ ]
              else
                [ "--argument-names=${def.argumentNames |> lib.toList |> lib.concatStringsSep " "}" ];
            modifiers =
              if !isSubmodule then
                ""
              else
                " "
                + builtins.concatStringsSep " " (
                  quoted "description" def.description
                  ++ quoted "wraps" def.wraps
                  ++ onEventFlags
                  ++ quoted "on-variable" def.onVariable
                  ++ quoted "on-signal" def.onSignal
                  ++ boolFlag "no-scope-shadowing" def.noScopeShadowing
                  ++ quoted "inherit-variable" def.inheritVariable
                  ++ argumentFlags
                );
          in
          lib.nameValuePair "fish/functions/${name}.fish" {
            text = ''
              function ${name}${modifiers}
                ${body}
              end
            '';
          }
        );

      completionFiles =
        cfg.completions
        |> lib.mapAttrs' (
          name: def:
          let
            body = if builtins.isAttrs def then def.body else def;
          in
          lib.nameValuePair "fish/completions/${name}.fish" { text = body; }
        );

      pluginFiles =
        cfg.plugins
        |> map (
          plugin:
          lib.nameValuePair "fish/conf.d/plugin-${plugin.name}.fish" {
            text = ''
              # Plugin ${plugin.name}
              set -l plugin_dir ${plugin.src}

              # Set paths to import plugin components
              if test -d $plugin_dir/functions
                set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
              end

              if test -d $plugin_dir/completions
                set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
              end

              # Source initialization code if it exists.
              if test -d $plugin_dir/conf.d
                for f in $plugin_dir/conf.d/*.fish
                  source $f
                done
              end

              if test -f $plugin_dir/key_bindings.fish
                source $plugin_dir/key_bindings.fish
              end

              if test -f $plugin_dir/init.fish
                source $plugin_dir/init.fish
              end
            '';
          }
        )
        |> builtins.listToAttrs;

      fishCompletions =
        let
          generateManpageCompletions =
            package:
            let
              name = "${package.pname or package.name}-fish-completions";
              manOutput = lib.optional (package ? outputs && builtins.elem "man" package.outputs) package.man;
            in
            pkgs.runCommand name
              {
                srcs = [ package ] ++ manOutput;
                nativeBuildInputs = [
                  pkgs.python3
                  (if cfg.package != null then cfg.package else pkgs.fish)
                ];
                preferLocalBuild = true;
              }
              ''
                # The generator script is embedded in the fish binary, so extract it.
                generator=$PWD/create_manpage_completions.py
                fish --no-config -c 'status get-file tools/create_manpage_completions.py' > "$generator"

                mkdir -p $out
                for src in $srcs; do
                  if [ -d $src/share/man ]; then
                    find -L $src/share/man -type f -exec python "$generator" --directory $out {} + > /dev/null
                  fi
                done
              '';

          packageCompletions =
            config.packages
            |> lib.sort (a: b: (a.meta.priority or 0) > (b.meta.priority or 0))
            |> map generateManpageCompletions;

          destructiveSymlinkJoin =
            paths:
            pkgs.runCommand "fish-generated-completions"
              {
                inherit paths;
                passAsFile = [ "paths" ];
                preferLocalBuild = true;
                allowSubstitutes = false;
              }
              ''
                mkdir -p $out
                for i in $(cat $pathsPath); do
                  if [ -z "$(find $i -prune -empty)" ]; then
                    cp -srf $i/* $out
                  fi
                done
              '';
        in
        destructiveSymlinkJoin packageCompletions;
    in
    {
      options.programs.fish =
        with lib.types;
        with lib;
        {

          enable = mkEnableOption {
            description = "Enable fish configuration";
          };

          package = mkPackageOption pkgs "fish" {
            extraDescription = "Set this to null if you use the Hjem module to install fish.";
            nullable = true;
          };

          shellInit = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Shell script code called during fish shell
              initialisation.
            '';
          };

          loginShellInit = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Shell script code called during fish login shell
              initialisation.
            '';
          };

          interactiveShellInit = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Shell script code called during interactive fish shell
              initialisation.
            '';
          };

          shellInitLast = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Shell script code called during interactive fish shell
              initialisation, this will be the last thing executed in fish startup.
            '';
          };

          shellAliases = mkOption {
            type = types.attrsOf types.str;
            default = { };
            description = ''
              An attribute set that maps aliases (the top level attribute names
              in this option) to command strings.
            '';
            example = {
              g = "git";
              "..." = "cd ../..";
            };
          };

          shellAbbrs = mkOption {
            type = types.attrsOf (types.either types.str abbrModule);
            default = { };
            description = ''
              An attribute set that maps abbreviations (the top level
              attribute names in this option) to abbreviations. Abbreviations
              are expanded with the longer phrase after they are entered.
            '';
            example = {
              l = "less";
              gco = "git checkout";
            };
          };

          functions = mkOption {
            type = types.attrsOf (types.either types.lines functionModule);
            default = { };
            description = ''
              Basic functions to add to fish. For more information see
              <https://fishshell.com/docs/current/cmds/function.html>.
            '';
          };

          completions = mkOption {
            type = types.attrsOf (types.either types.lines completionModule);
            default = { };
            description = ''
              Custom fish completions. For more information see
              <https://fishshell.com/docs/current/completions.html>.
            '';
          };

          plugins = mkOption {
            type = types.listOf pluginModule;
            default = [ ];
            description = ''
              The plugins to source in
              {file}`conf.d/99plugins.fish`.
            '';
          };

          binds = mkOption {
            type = types.attrsOf bindModule;
            default = { };
            description = "Manage key bindings";
            example = {
              "alt-shift-b".command = "fish_commandline_append bat";
              "alt-s".erase = true;
              "alt-s".operate = "preset";
            };
          };

          generateCompletions = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Automatically generate completions from the installed
              packages' man pages.
            '';
          };

        };

      config = lib.mkIf cfg.enable {

        assertions =
          cfg.binds
          |> lib.mapAttrsToList (
            key: def: {
              assertion = def.erase || def.command != null;
              message = "programs.fish.binds.${key} must define either erase or command";
            }
          );

        packages = lib.optionals (cfg.package != null) [ cfg.package ];

        programs.fish.functions = lib.mkIf (filteredBinds != { }) {
          fish_user_key_bindings = bindsStr;
        };

        xdg.config.files = lib.mkMerge [
          {
            "fish/config.fish".text = # fish
              ''
                # ~/.config/fish/config.fish: DO NOT EDIT -- this file has been generated
                # automatically by hjem.

                # Only execute this file once per shell.
                set -q __fish_hjem_config_sourced; and exit
                set -g __fish_hjem_config_sourced 1

                source ${sessionVars}

                # Source handler functions
                ${sourceHandlersStr}

                ${cfg.shellInit}

                status is-login; and begin
                  # Login shell initialisation
                  ${cfg.loginShellInit}
                end

                status is-interactive; and begin
                  # Abbreviations
                  ${abbrsStr}

                  # Aliases
                  ${aliasesStr}
                  ${lib.optionalString cfg.generateCompletions ''
                    # Add completions generated by hjem to $fish_complete_path
                    set fish_complete_path $fish_complete_path "${config.xdg.data.directory}/fish/hjem/generated_completions"
                  ''}

                  # Interactive shell initialisation
                  ${cfg.interactiveShellInit}
                end

                ${cfg.shellInitLast}
              '';
          }

          # Generate the user defined functions
          functionFiles

          # Generate the user defined completions
          completionFiles

          # Generate a conf.d loader per plugin
          pluginFiles
        ];

        xdg.data.files = lib.mkIf cfg.generateCompletions {
          "fish/hjem/generated_completions".source = fishCompletions;
        };

      };
    };
}
