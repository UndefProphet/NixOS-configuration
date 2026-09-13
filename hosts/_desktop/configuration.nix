{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake.nixosConfigurations =
    let
      # stateVersion = lib.trivial.oldestSupportedRelease;
      stateVersion = "25.11";
      system = "x86_64-linux";
      configurationName = "desktop";

      # Gpu passthrough
      gpu-iommu-ids = [
        "10de:1f06"
        "10de:10f9"
        "10de:1ada"
        "10de:1adb"
      ];

      username = "tar";
      hostname = "deskman";
      homedir = "/home/${username}";
      configdir = "${homedir}/.nixos";
    in
    {
      desktop = withSystem "x86_64-linux" (
        { self', inputs', ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit stateVersion;
            inherit username;
            inherit hostname;
            inherit homedir;
            inherit configdir;
            inherit configurationName;
            inherit self';
            inherit inputs';
          };

          modules = with self.modules.nixos; [
            # default
            desktop
            common

            # Nixos
            virtualisation
            gpu-passthrough
            {
              _module.args = {
                ids = gpu-iommu-ids;
              };
            }
          ];
        }
      );
    };
}
