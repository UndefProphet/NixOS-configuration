{
  lib,
  ...
}:
{
  flake.modules.nixos.desktop = { modulesPath, config, ... }: {
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
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # Amd cpu support for different programs like btop
    nixpkgs.config.rocmSupport = true;
  };
}
