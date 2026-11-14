{
  self,
  lib,
  inputs,
  withSystem,
  extendedLib,
  ...
}:
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

  # flake-parts declares `flake.nixosConfigurations` as lazyAttrsOf raw;
  # disable it so the typed option below is the only declaration.
  disabledModules = [ (inputs.flake-parts + "/modules/nixosConfigurations.nix") ];

  options.flake.nixosConfigurations = lib.mkOption {
    description = "Nixos configurations.";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {

          system = lib.mkOption {
            description = "System architecture.";
            type = lib.types.str;
          };

          hostName = lib.mkOption {
            description = "System hostname.";
            type = lib.types.str;
          };

          configurationName = lib.mkOption {
            description = "Name of this configuration.";
            type = lib.types.str;
            default = "unknown";
          };

          stateVersion = lib.mkOption {
            description = "state version to use.";
            type = lib.types.str;
          };

          username = lib.mkOption {
            description = "Username.";
            type = lib.types.str;
          };

          configuration = lib.mkOption {
            description = "module configurations.";
            type = lib.types.deferredModule;
            default = { };
          };

          extraModules = lib.mkOption {
            description = "Extra modules to import.";
            type = lib.types.listOf lib.types.deferredModule;
            default = [ ];
          };

        };
      }
    );

    apply =
      hosts:
      hosts
      |> lib.mapAttrs (
        _: host:
        withSystem host.system (
          { self', inputs', ... }:
          inputs.nixpkgs.lib.nixosSystem {
            inherit (host) system;
            specialArgs = {
              lib = extendedLib inputs'.nixpkgs;
              inherit
                self'
                inputs'
                inputs
                ;

              inherit (host)
                stateVersion
                hostName
                configurationName
                username
                ;
            };
            modules = [
              host.configuration
              { system.stateVersion = host.stateVersion; }
            ]
            ++ nixos-modules
            ++ host.extraModules;
          }
        )
      );
  };
}
