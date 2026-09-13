{ inputs, ... }: {
  # https://github.com/nix-community/home-manager
  # Provides a module system for managing a user environment.
  tack.inputs.home-manager = "gh:nix-community/home-manager?ref=master";

  flake.modules.nixos.home-manager =
    {
      lib,
      username,
      stateVersion,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
      ];

      home-manager = {
        verbose = true;
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        backupCommand = "rm";
        overwriteBackup = true;
      };

      hm.home = { inherit stateVersion; };
    };
}
