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
            {
              content,
              fileName ? "lua-file",
            }:
            let
              luaFile = pkgs.writeText "${fileName}.lua" content;
              result = pkgs.runCommand "lua-check" { } ''
                ${pkgs.lua}/bin/luac -p ${luaFile}; 
                echo valid > $out
              '';
            in
            (builtins.readFile result) == "valid\n";

        };

        pretty = {
          jsonText =
            text:
            builtins.readFile (
              pkgs.runCommand "pretty-json"
                {
                  nativeBuildInputs = [ pkgs.jq ];
                }
                ''
                  echo '${text}' | jq . > $out
                ''
            );
        };
      }
    );

in
{
  _module.args = {
    inherit extendedLib;
  };
}
