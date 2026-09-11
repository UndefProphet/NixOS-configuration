{
  inputs,
  lib,
  self,
  extendedLib,
  ...
}:
let
  unwrap = module: builtins.head (module { }).imports;
  hjem-modules = lib.attrValues self.modules.hjem-modules |> map unwrap;
in
{
  tack.inputs.hjem = "gh:feel-co/hjem?ref=main";

  # Wire hjem into NixOS and expose the user configuration as `hj`.
  flake.modules.nixos.hjem =
    {
      config,
      pkgs,
      username,
      homedir,
      self',
      inputs',
      ...
    }:
    {
      imports = [
        inputs.hjem.nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" username ])
      ];

      hjem = {
        clobberByDefault = true;
        users.${username} = {
          enable = true;
          directory = homedir;
        };
        specialArgs = {
          lib = extendedLib pkgs;
          inherit
            self'
            inputs'
            ;
        };
        extraModules = hjem-modules;
      };

      hj = {
        files.".profile" = {
          executable = true;
          source = config.hj.environment.loadEnv;
        };
      };
    };

  # Namespace for hjem submodules; seeded so it is always defined.
  flake.modules.hjem-modules = { };
}
