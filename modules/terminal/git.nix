{ lib, ... }: {
  flake.modules.nixos.git = { config, ... }: {

    options.conf.terminal.git.enable = lib.mkEnableOption { };

    config =
      let
        cfg = config.conf.terminal.git;
      in
      lib.mkIf cfg.enable {
        hm = {
          programs.git = {
            enable = true;
          };

          services.ssh-agent = {
            enable = true;
          };
        };
      };
  };
}
