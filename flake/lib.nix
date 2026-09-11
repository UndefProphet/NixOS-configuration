{
  self,
  lib,
  withSystem,
  inputs,
  ...
}:
let

  extendedLib =
    pkgs:
    inputs.nixpkgs.lib.extend (
      final: prev: {

        # Validators for different languages.
        validators = {

          validateLua =
            content:
            let
              luaFile = pkgs.writeText "lua-file.lua" content;

              result = pkgs.runCommand "lua-check" { } ''
                if ${pkgs.lua}/bin/luac -p ${luaFile}; then
                  echo valid > $out
                else
                  echo "Lua validation failed:" >&2
                  ${pkgs.lua}/bin/luac -p ${luaFile} >&2
                  exit 1
                fi
              '';
            in
            (builtins.readFile result) == "valid\n";

        };
      }
    );

  mkNixosUserSystem =
    let
      unwrap = module: builtins.head (module { }).imports;
      excluded = [ "common" ];
      nixos-modules =
        let
          mods = self.modules.nixos;
          include = name: !builtins.elem name excluded;
        in
        lib.attrNames mods |> lib.filter include |> map (name: unwrap mods.${name});
    in
    {
      system, # System type
      hostName, # System hostname
      configurationName,
      stateVersion,
      username,
      homedir ? "/home/${username}",
      configdir ? "/home/${username}/.nixos",
      configuration ? { },
      extraModules ? [ ],
    }:
    withSystem system (
      { self', inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          # Overrides the `lib` module argument so modules can use
          # helpers like `lib.validators.validateLua`.
          lib = extendedLib inputs'.nixpkgs;
          inherit
            self'
            inputs'
            inputs
            ;

          inherit
            stateVersion
            hostName
            configurationName
            username
            homedir
            configdir
            ;
        };
        modules = [
          configuration
          { system.stateVersion = lib.mkDefault stateVersion; }
        ]
        ++ nixos-modules
        ++ extraModules;
      }
    );

in
{
  _module.args = {
    inherit mkNixosUserSystem extendedLib;
  };
}
