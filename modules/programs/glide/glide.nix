{ lib, ... }: {
  flake.modules.nixos.glide =
    { config, pkgs, ... }:
    let
      cfg = config.conf.programs.glide;
    in
    {
      options.conf.programs.glide.enable = lib.mkEnableOption {
        description = "Enable glide browser";
      };

      config = lib.mkIf cfg.enable {
        hj.programs.glide = {
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
                  "browser.aboutConfig.showWarning" = true;
                  "browser.startup.page" = 3; # restore session on startup
                  "layout.css.heading-selector.enabled" = true;
                  "layout.css.has-selector.enabled" = true;
                  "browser.tabs.allow_transparent_browser" = true; # Enable transparency in the browser window.

                  # Sidebar
                  "sidebar.verticalTabs" = true; # Vertical tabs.
                  "sidebar.expandOnHover" = true; # Expand on hover.
                  "sidebar.animation.enabled" = false; # Make everything instant.
                  "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks"; # Sidebar utilities at the bottom.
                };

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

        hj.xdg.mime-apps =
          let
            browser = [ "glide-browser.desktop" ];
          in
          {
            default-applications = {
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

            added-associations = {
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

        hj.files.".local/share/applications/glide-incognito.desktop".text = ''
          [Desktop Entry]
          Name=Glide Incognito
          GenericName=Web Browser
          Exec=glide --private-window
          Icon=glide
          Type=Application
          Categories=Network;WebBrowser;
        '';
      };
    };
}
