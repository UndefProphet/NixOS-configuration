{ lib, ... }: {
  flake.modules.nixos.glide =
    { config, ... }:
    let
      cfg = config.conf.programs.glide;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.programs.glide.configuration = # Typescript
          ''
            // Navigation
            glide.keymaps.set("normal", "<C-h>", "back");
            glide.keymaps.set("normal", "<C-l>", "forward");

            // Tabs
            glide.keymaps.set("normal", "d", "tab_close");
            glide.keymaps.set("normal", "u", "tab_reopen");

            // Generic
            glide.keymaps.set("normal", "U", "tab_reopen");
          '';
      };
    };
}
