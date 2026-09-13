{ lib, ... }: {
  flake.modules.nixos.display-manager =
    {
      lib,
      config,
      pkgs,
      username,
      ...
    }:
    {
      options.conf.environment.desktop-manager.greetd.enable = lib.mkEnableOption { };

      config =
        let
          cfg = config.conf.environment.desktop-manager.greetd;
        in
        lib.mkIf cfg.enable {
          services.greetd = {
            enable = true;
            useTextGreeter = true;
            settings = {
              default_session = {
                # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
                command = lib.concatStringsSep " " [
                  "${pkgs.tuigreet}/bin/tuigreet"
                  # Behaviour
                  # Remember username and session
                  "--remember"
                  "--remember-session"

                  "--user-menu"

                  # Theme
                  "--time"
                  "--greeting 'WELCOME'"
                  "--asterisks"
                  # "border=magenta';'text=cyan';'prompt=green';'time=red';'action=blue';'button=yellow';'container=black';'input=red"
                ];
                user = username;
              };
            };
          };
        };
    };
}
