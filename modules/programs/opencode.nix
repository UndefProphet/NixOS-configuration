{ lib, ... }: {
  flake.modules.nixos.fish =
    {
      config,
      pkgs,
      username,
      ...
    }:
    let
      cfg = config.conf.programs.opencode;
    in
    {
      options.conf.programs.opencode = {

        enable = lib.mkEnableOption {
          description = "Enable opencode";
        };

      };

      config = lib.mkIf cfg.enable {

        hj.programs.opencode = {
          enable = true;
          tui.theme = lib.mkForce "system";
          # enableMcpIntegration = true;

          extraPackages = with pkgs; [
            nodejs
          ];

          settings = {

            mcp = {
              context7 = {
                enabled = true;
                type = "remote";
                url = "https://mcp.context7.com/mcp";
                headers = {
                  "CONTEXT7_API_KEY" = "{file:${config.sops.secrets."mcp/context7".path}}";
                };
              };

              tavily = {
                enabled = true;
                type = "local";
                command = [
                  "npx"
                  "-y"
                  "tavily-mcp"
                ];
                url = "https://mcp.tavily.com/mcp";
                environment = {
                  TAVILY_API_KEY = "{file:${config.sops.secrets."mcp/tavily".path}}";
                };
              };
            };
          };
        };

      };
    };
}
