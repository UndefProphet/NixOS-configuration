{ lib, ... }: {
  flake.modules.nixos.tmux = { config, ... }: {
    options.conf.terminal.tmux.enable = lib.mkEnableOption { };

    config =
      let
        cfg = config.conf.terminal.tmux;
      in
      lib.mkIf cfg.enable {
        hm.programs.tmux = {
          enable = true;
          terminal = "screen";
          mouse = true;
          keyMode = "vi";
          focusEvents = false;
          aggressiveResize = false;
          baseIndex = 1;
          clock24 = true;

          extraConfig = /* conf */ ''
            set -g status-keys vi

            set -s escape-time       500
            set -g history-limit     2000

            set -g pane-base-index 1

            # unbind-key -a # Unbind all keys
            set -g prefix C-Space
            bind C-space send-prefix
          '';
        };
      };
  };
}
