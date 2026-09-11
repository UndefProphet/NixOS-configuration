{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      hostName,
      ...
    }:
    let
      cfg = config.conf.networking;
    in
    {
      imports = [
        {
          options.conf.networking = {
            enable = lib.mkEnableOption {
              default = false;
              description = "Enable networking configuration";
            };
            wifi = {
              enable = lib.mkEnableOption {
                description = "Enable wifi";
              };
              eduroam = { }; # https://wiki.nixos.org/wiki/Iwd#:~:text=eduroam,-eduroam
            };
          };
        }
      ];

      config =
        lib.mkIf cfg.enable
        <| lib.mkMerge [
          {
            networking = {
              hostName = hostName;
              firewall.enable = true;
              useDHCP = lib.mkForce true;
              networkmanager.enable = true;
            };
          }

          # WIFI
          (lib.mkIf cfg.wifi.enable {
            networking = {
              networkmanager.wifi.backend = "iwd";
              wireless.iwd.enable = true;
            };

            # At least one keyring is required for storing wifi passwords
            services.gnome.gnome-keyring.enable = lib.mkDefault true;
          })

        ];
    };
}
