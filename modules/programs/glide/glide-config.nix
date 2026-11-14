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

            // Keep the vertical-tabs sidebar at 10vw even after a manual resize.
            // Firefox stores the dragged width in sidebar state and applies it as
            // an inline style on #sidebar-container (plus a customWidth attribute
            // on sidebar-main), which is why only the tabs inside changed before.
            glide.autocmds.create("ConfigLoaded", () => {
              document.documentElement.style.setProperty(
                "--sidebar-expanded-launcher-width",
                "10vw",
              );
            });

            glide.styles.add(css`
              #sidebar-container[sidebar-launcher-expanded],
              #sidebar-container:has(> sidebar-main[expanded]) {
                width: 10vw !important;
                min-width: 10vw !important;
                max-width: 10vw !important;
              }
            `);
          '';
      };
    };
}
