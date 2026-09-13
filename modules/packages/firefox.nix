{ inputs, lib, ... }: {
  tack.inputs.glide-browser = "gh:glide-browser/glide.nix";

  flake.modules.nixos.firefox =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.conf.packages.firefox;
    in
    {
      options.conf.packages.firefox.enable = lib.mkEnableOption {
        description = "Enable firefox";
      };

      config = lib.mkIf cfg.enable {
        # Home manager
        hm = { config, ... }: {
          imports = [ inputs.glide-browser.homeModules.default ];

          programs.glide-browser = {
            enable = true;
            nativeMessagingHosts = [ pkgs.keepassxc ];

            profiles =
              let
                defaults = {
                  settings = {
                    # Features
                    "image.jxl.enabled" = true;

                    # Themeing
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.
                    "browser.aboutConfig.showWarning" = true; # Disable about:config warning.
                    "browser.startup.page" = 3; # restore session on startup
                    "layout.css.heading-selector.enabled" = true;
                    "layout.css.has-selector.enabled" = true;
                    "browser.tabs.allow_transparent_browser" = true; # Enable transperancy in the browser window.

                    # Sidebar
                    "sidebar.verticalTabs" = true; # Vertical tabs.
                    # "sidebar.visibility" = "expand-on-hover"; # Expand on hover.
                    "sidebar.expandOnHover" = true; # Expand on hover.
                    "sidebar.animation.enabled" = false; # Make everything instant.
                    "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks"; # Sidebar utilities at the bottom.
                  };

                  # userChrome = ''
                  #   :root {
                  #     --tabpanel-background-color: transparent !important; /* browser background */
                  #
                  #     --toolbox-bgcolor: #1d2021d9 !important;
                  #     --toolbox-bgcolor-inactive: #1d2021d9 !important;
                  #   }
                  # '';

                  extensions = {
                    force = true;
                    packages = with pkgs.nur.repos.rycee.firefox-addons; [
                      keepassxc-browser
                      ublock-origin
                      sponsorblock
                      firefox-color
                    ];
                    settings = {
                      "FirefoxColor@mozilla.com".settings = {
                        firstRunDone = true;
                        # theme =
                        #   let
                        #     mkColor = color: {
                        #
                        #       r = config.lib.stylix.colors."${color}-rgb-r";
                        #       g = config.lib.stylix.colors."${color}-rgb-g";
                        #       b = config.lib.stylix.colors."${color}-rgb-b";
                        #     };
                        #   in
                        #   {
                        #     title = "Stylix ${config.lib.stylix.colors.description}";
                        #     images.additional_backgrounds = [ "./bg-000.svg" ];
                        #     colors = {
                        #       toolbar = mkColor "base00";
                        #       toolbar_text = mkColor "base05";
                        #       frame = mkColor "base01";
                        #       tab_background_text = mkColor "base05";
                        #       toolbar_field = mkColor "base02";
                        #       toolbar_field_text = mkColor "base05";
                        #       tab_line = mkColor "base0D";
                        #       popup = mkColor "base00";
                        #       popup_text = mkColor "base05";
                        #       button_background_active = mkColor "base04";
                        #       frame_inactive = mkColor "base00";
                        #       icons_attention = mkColor "base0D";
                        #       icons = mkColor "base05";
                        #       ntp_background = mkColor "base00";
                        #       ntp_text = mkColor "base05";
                        #       popup_border = mkColor "base0D";
                        #       popup_highlight_text = mkColor "base05";
                        #       popup_highlight = mkColor "base04";
                        #       sidebar_border = mkColor "base0D";
                        #       sidebar_highlight_text = mkColor "base05";
                        #       sidebar_highlight = mkColor "base0D";
                        #       sidebar_text = mkColor "base05";
                        #       sidebar = mkColor "base00";
                        #       tab_background_separator = mkColor "base0D";
                        #       tab_loading = mkColor "base05";
                        #       tab_selected = mkColor "base00";
                        #       tab_text = mkColor "base05";
                        #       toolbar_bottom_separator = mkColor "base00";
                        #       toolbar_field_border_focus = mkColor "base0D";
                        #       toolbar_field_border = mkColor "base00";
                        #       toolbar_field_focus = mkColor "base00";
                        #       toolbar_field_highlight_text = mkColor "base00";
                        #       toolbar_field_highlight = mkColor "base0D";
                        #       toolbar_field_separator = mkColor "base0D";
                        #       toolbar_vertical_separator = mkColor "base0D";
                        #     };
                        #   };
                      };
                    };
                  };

                  search.force = true;
                  search.engines = {
                    # Nix packages
                    nix-packages = {
                      name = "Nix Packages";
                      urls = [
                        {
                          template = "https://search.nixos.org/packages";
                          params = [
                            {
                              name = "channel";
                              value = "unstable";
                            }
                            {
                              name = "query";
                              value = "{searchTerms}";
                            }
                          ];
                        }
                      ];
                      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                      definedAliases = [ "nixp" ];
                    };

                    # Nix options
                    nix-options = {
                      name = "Nix Options";
                      urls = [
                        {
                          template = "https://search.nixos.org/options";
                          params = [
                            {
                              name = "channel";
                              value = "unstable";
                            }
                            {
                              name = "query";
                              value = "{searchTerms}";
                            }
                          ];
                        }
                      ];
                      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                      definedAliases = [ "nixo" ];
                    };

                    # Home manager options
                    home-options = {
                      name = "Nix Home Manager";
                      urls = [
                        {
                          template = "https://home-manager-options.extranix.com";
                          params = [
                            {
                              name = "release";
                              value = "master";
                            }
                            {
                              name = "query";
                              value = "{searchTerms}";
                            }
                          ];
                        }
                      ];
                      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                      definedAliases = [ "hm" ];
                    };
                  };
                };

              in
              {
                default = defaults // {
                  name = "default";
                  isDefault = true;
                  id = 0;
                };
                streaming = defaults // {
                  name = "streaming";
                  isDefault = false;
                  id = 1;
                };
              };
          };

          xdg.mimeApps =
            let
              browser = [ "glide-browser.desktop" ];
            in
            lib.mkIf config.programs.glide-browser.enable {
              defaultApplications = {
                "x-scheme-handler/http" = browser;
                "x-scheme-handler/https" = browser;
                "x-scheme-handler/chrome" = browser;
                "text/html" = browser;
                "application/x-extension-htm" = browser;
                "application/x-extension-html" = browser;
                "application/x-extension-shtml" = browser;
                "application/xhtml+xml" = browser;
                "application/x-extension-xhtml" = browser;
                "application/x-extension-xht" = browser;
              };

              associations.added = {
                "x-scheme-handler/http" = browser;
                "x-scheme-handler/https" = browser;
                "x-scheme-handler/chrome" = browser;
                "text/html" = browser;
                "application/x-extension-htm" = browser;
                "application/x-extension-html" = browser;
                "application/x-extension-shtml" = browser;
                "application/xhtml+xml" = browser;
                "application/x-extension-xhtml" = browser;
                "application/x-extension-xht" = browser;
              };
            };

          # Firefox Incognito
          xdg.desktopEntries = {
            firefox-incognito = {
              name = "Firefox Incognito";
              genericName = "Web Browser";
              icon = "firefox";
              exec = "firefox --private-window";
              terminal = false;

              categories = [
                "Application"
                "Network"
                "WebBrowser"
              ];

              mimeType = [
                "text/html"
                "text/xml"
              ];
            };
          };
        };
      };
    };
}
