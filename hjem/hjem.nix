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
      self',
      inputs',
      username,
      ...
    }:
    let
      cfg = config.conf.system.hjem;
    in
    {
      options.conf.system.hjem.enable = lib.mkEnableOption { };

      imports = [
        inputs.hjem.nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" username ])
      ];

      config = lib.mkMerge [
        {
          hjem = {
            clobberByDefault = true;
            specialArgs = {
              lib = extendedLib pkgs;
              inherit
                self'
                inputs
                inputs'
                ;
            };
            # User option declarations are needed unconditionally so that
            # `hj.*` definitions path-check even when hjem is disabled.
            extraModules = hjem-modules;
            users.${username}.enable = cfg.enable;
          };
        }

        (lib.mkIf cfg.enable {
          hj.files.".profile" = {
            executable = true;
            source = config.hj.environment.loadEnv;
          };
        })
      ];
    };

  # Namespace for hjem submodules; seeded so it is always defined.
  flake.modules.hjem-modules = { };
}
