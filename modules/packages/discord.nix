{ inputs, lib, ... }: {
  # https://github.com/not-a-cowfr/equinix
  # Discord client with modified vencord plugins.
  tack.inputs.nixcord = "gh:FlameFlag/nixcord?ref=main";

  flake.modules.nixos.discord =
    { config, ... }:
    let
      cfg = config.conf.packages.discord;
    in
    {
      options.conf.packages.discord.enable = lib.mkEnableOption {
        description = "Enable discord";
      };

      config = lib.mkIf cfg.enable {
        home-manager.sharedModules = [ inputs.nixcord.homeModules.nixcord ];

        hm = {
          programs.abaddon.enable = true;
          programs.nixcord = {
            enable = true;
            equibop.enable = true;
            discord = {
              # enable = false;
              vencord.enable = false;
              equicord.enable = true;
              # equicord.package = pkgs.equibop;
            };

            userPlugins = { };
            #
            config = {
              transparent = true;
              useQuickCss = true;
              autoUpdate = true;
              frameless = true;
              plugins = {
                roleColorEverywhere.enable = true;
                messageLoggerEnhanced.enable = true;
                showHiddenChannels.enable = true;
                showHiddenThings.enable = true;
                showResourceChannels.enable = true;
                whosWatching.enable = true;
                silentTyping.enable = true;

                crashHandler = {
                  enable = false;
                  attemptToPreventCrashes = true;
                  attemptToNavigateToHome = false;
                };
              };
            };
            extraConfig = { };
          };
        };
      };
    };
}
