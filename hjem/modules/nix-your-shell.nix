{ lib, ... }:
{
  flake.modules.hjem-modules.nix-your-shell =
    { config, pkgs, ... }:
    let
      cfg = config.programs.nix-your-shell;
    in
    {
      options.programs.nix-your-shell = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "nix-your-shell" { };

        nix-output-monitor = {
          enable = lib.mkEnableOption ''
            [nix-output-monitor](https://github.com/maralorn/nix-output-monitor) to get
            additional information while building
          '';

          package = lib.mkPackageOption pkgs "nix-output-monitor" { };
        };
      };

      config = lib.mkIf cfg.enable {
        packages =
          [ cfg.package ]
          ++ lib.optionals cfg.nix-output-monitor.enable [ cfg.nix-output-monitor.package ];

        programs.fish.interactiveShellInit = ''
          ${lib.getExe cfg.package} ${lib.optionalString cfg.nix-output-monitor.enable "--nom "}fish | source
        '';
      };
    };
}
