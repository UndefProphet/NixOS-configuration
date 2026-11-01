{ lib, ... }: {

  flake.modules.nixos.audio = { config, pkgs, ... }: {

    options.conf.system.audio.enable = lib.mkEnableOption {
      description = "Enable audio";
    };

    config =
      let
        cfg = config.conf.system.audio;
      in
      lib.mkIf cfg.enable {
        services.pulseaudio.enable = false;
        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = true;
        security.rtkit.enable = true;
        services.playerctld.enable = true; # Enable to manage audio from audio sources.

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;

          wireplumber = {
            enable = true;
          };

          # Audio configuration for seperating audio sources.
          # Note: node.name must be unique otherwise programs like obs is connecting to first instance of name.
          # pw-loopback --name='test' --capture-props='node.description="test monitor" media.class=Audio/Sink node.name=test-capture audio.position=[FL FR]' --playback-props='node.description="test" node.name=test-playback audio.position=[FL FR] target.object=headphone-capture'
          extraConfig.pipewire = {
            "audio-seperation-setup" = {
              # "context.properties" = {
              #   "default.clock.allowed-rates" = [ 48000 ];
              #   "default.clock.min-quantum"   = 32;
              #   "default.clock.max-quantum"   = 2048;
              # };

              "context.modules" = [
                # Remap the default microphone
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "name" = "Microphone";
                    "node.description" = "Microphone";

                    # Autoconnect to default input device
                    "capture.props" = {
                      "node.name" = "microphone-capture";
                      "node.passive" = true;
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                    };
                    "playback.props" = {
                      "node.name" = "microphone-playback";
                      "media.class" = "Audio/Source";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "stream.dont-remix" = true;
                      "node.passive" = true;
                    };
                  };
                }

                # Remap the default headphone
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "name" = "Headpones";
                    "node.description" = "Headphone";
                    "capture.props" = {
                      "node.name" = "headphone-capture";
                      "node.passive" = true;
                      "media.class" = "Audio/Sink";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                    };

                    # Auto connect to default output device
                    "playback.props" = {
                      "node.name" = "headphone-playback";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "stream.dont-remix" = true;
                      "node.passive" = true;
                    };
                  };
                }

                # Discord
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Discord Monitor";
                    "capture.props" = {
                      "node.name" = "discord-capture";
                      "node.passive" = true;
                      "media.class" = "Audio/Sink";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                    };
                    "playback.props" = {
                      "node.description" = "Discord";
                      "node.name" = "discord-playback";
                      "node.passive" = true;
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "stream.dont-remix" = true;
                      "target.object" = "headphone-capture";
                    };
                  };
                }

                # Music
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Music Monitor";
                    "capture.props" = {
                      "node.name" = "music-capture";
                      "node.passive" = true;
                      "media.class" = "Audio/Sink";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                    };
                    "playback.props" = {
                      "node.description" = "Music";
                      "node.name" = "music-playback";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "stream.dont-remix" = true;
                      "node.passive" = true;
                      "target.object" = "headphone-capture";
                    };
                  };
                }

                # Games
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Games Monitor";
                    "capture.props" = {
                      "node.name" = "games-capture";
                      "node.passive" = true;
                      "media.class" = "Audio/Sink";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                    };
                    "playback.props" = {
                      "node.description" = "Games";
                      "node.name" = "games-playback";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "stream.dont-remix" = true;
                      "node.passive" = true;
                      "target.object" = "headphone-capture";
                    };
                  };
                }

                # Browser
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Browser Monitor";
                    "capture.props" = {
                      "node.name" = "browser-capture";
                      "node.passive" = true;
                      "media.class" = "Audio/Sink";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                    };
                    "playback.props" = {
                      "node.description" = "Browser";
                      "node.name" = "browser-playback";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "stream.dont-remix" = true;
                      "node.passive" = true;
                      "target.object" = "headphone-capture";
                    };
                  };
                }

                # VoIP
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "VoIP Monitor";
                    "capture.props" = {
                      "node.name" = "voip-capture";
                      "node.passive" = true;
                      "media.class" = "Audio/Sink";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                    };
                    "playback.props" = {
                      "node.description" = "VoIP";
                      "node.name" = "voip-playback";
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "stream.dont-remix" = true;
                      "node.passive" = true;
                      "target.object" = "headphone-capture";
                    };
                  };
                }
              ];
            };
          };

        };
      };
  };
}
