{
  lib,
  modulesPath,
  config,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Amd cpu support for different programs like btop
  nixpkgs.config.rocmSupport = true;

  boot.kernelParams = [
    # Fix for getting stuck during boot
    "amdgpu.dcdebugmask=0x400"

    # Hardware
    "amdgpu.gpu_recovery=1" # Enables automatic recovery if the GPU hangs
    "amdgpu.gfx_off=0" # Disables GFXoff if experiencing power-state instability
    "iommu=pt" # Improves IOMMU passthrough performance
  ];

  boot.extraModprobeConfig = ''
    options asus_nb_wmi wapf=4
  '';

  services.scx = {
    enable = true;
    scheduler = "scx_p2dq";
  };

  # Battery
  # services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.displayManager.ly = {
    settings = {
      battery_id = "BAT0";
    };
  };

  services.tlp = {
    enable = true;
    settings = {
      TLP_PROFILE_AC = "balanced";
      TLP_PROFILE_BAT = "balanced";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_SAV = "power";
    };
  };

  # Make the mic-mute LED writable by the user so the user service below can
  # drive it (sysfs attributes are root-only by default).
  services.udev.extraRules = ''
    SUBSYSTEM=="leds", KERNEL=="platform::micmute", ACTION=="add|change", RUN+="${pkgs.coreutils}/bin/chgrp users /sys/class/leds/platform::micmute/brightness", RUN+="${pkgs.coreutils}/bin/chmod 0660 /sys/class/leds/platform::micmute/brightness"
  '';

  systemd.user.services.micmute-led = {
    description = "Sync mic-mute LED with default source mute";
    # pactl (pulseaudio) and awk are not part of the minimal default service PATH.
    path = [
      pkgs.pulseaudio
      pkgs.gawk
    ];
    serviceConfig = {
      ExecStart =
        pkgs.writers.writeBash "mic-light-handler"
          # bash
          ''
            set -euo pipefail

            LED="''${MICMUTE_LED:-/sys/class/leds/platform::micmute/brightness}"

            get_mute() {
              pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}'
            }

            set_led() {
              if [[ "$1" == "yes" ]]; then
                printf '1' >"$LED" 2>/dev/null || true
              else
                printf '0' >"$LED" 2>/dev/null || true
              fi
            }

            # Wait for the udev rule to make the LED writable before the first sync.
            for _ in {1..50}; do
              [[ -w "$LED" ]] && break
              sleep 0.1
            done
            [[ -w "$LED" ]] || echo "micmute-led: $LED is not writable; check services.udev.extraRules" >&2

            sync() {
              set_led "$(get_mute)"
            }

            sync

            pactl subscribe | while read -r line; do
              case "$line" in
                "Event 'change' on source"* | "Event 'new' on source"* | "Event 'remove' on source"* | "Event 'change' on server"*)
                  sync
                  ;;
              esac
            done
          '';
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  hm.services.wluma = {
    enable = true;
    settings = {

      als.iio = {
        path = "/sys/bus/iio/devices";
        thresholds = {
          "0" = "night";
          "15" = "dark";
          "50" = "dim";
          "150" = "normal";
          "300" = "bright";
          "450" = "outdoors";
        };
      };

      output.backlight = [
        {
          name = "eDP-1";
          path = "/sys/class/backlight/amdgpu_bl1";
          capturer = "none";
        }
      ];

      keyboard = [
        {
          name = "keyboard-asus";
          path = "/sys/class/leds/asus::kbd_backlight";
        }
      ];
    };
  };
}
