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
                  "CONTEXT7_API_KEY" = "ctx7sk-95e9f56b-d18c-41f4-a76b-03a83df7e908";
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
                  TAVILY_API_KEY = "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";
                };
              };
            };
          };
        };

      };
    };
}
