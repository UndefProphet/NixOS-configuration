{
  self,
  inputs,
  ...
}:
{
  perSystem = {
    packages.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };

  flake.nixosConfigurations =
    let
      stateVersion = "25.11";
      system = "x86_64-linux";

    in
    {
      iso = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          # inherit stateVersion;
          # inherit configurationName;
        };

        modules = with self.modules.nixos; [
          ({ modulesPath, ... }: {
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
          })

          iso
        ];
      };
    };
}
