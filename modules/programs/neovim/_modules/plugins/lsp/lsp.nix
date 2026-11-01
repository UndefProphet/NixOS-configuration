{ pkgs, ... }: {
  plugins.lsp = {
    enable = true;
    servers =
      builtins.mapAttrs
        (
          _name: opts:
          {
            enable = true;
            package = null;
          }
          // opts
        )
        {
          nixd = {
            package = pkgs.nixd;
          };
          nil_ls = {
            package = pkgs.nil;
          };

          # Web
          ts_ls = { };
          html = { };
          cssls = { };
          jsonls = { };

          #
          pyright = { };
          gopls = { };
          lua_ls = { };
          rust_analyzer = {
            installRustc = true;
            installCargo = true;
          };
          omnisharp = { };

          # Other
          veryl_ls = { };

          # Config / Infra
          yamlls = { };
          bashls = { };
          dockerls = { };

          # UI
          qmlls = { }; # QT/qml
        };
  };

  filetype.extension."veryl" = "veryl";
}
