{ lib, pkgs, ... }:
let
  # nowait so Space fires immediately instead of dangling on the global <leader><Space> sequence
  toggleSelect = lib.nixvim.mkRaw ''
    {
      require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_worse,
      type = "action",
      opts = { nowait = true, desc = "Toggle selection" },
    }
  '';
in
{
  plugins.telescope = {
    enable = true;

    extensions.fzf-native.enable = true;

    settings = {
      pickers.buffers.mappings.n = {
        " " = toggleSelect;
        d = lib.nixvim.mkRaw "require('telescope.actions').delete_buffer";
      };
    };
  };

  extraPackages = [
    pkgs.ripgrep # required for explorer search
  ];
}
