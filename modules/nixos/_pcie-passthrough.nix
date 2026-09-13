{
  flake.modules.nixos.gpu-passthrough =
    {
      ids,
      ...
    }:
    {

      boot.initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"

        "amdgpu"

        # "radeon"
        # "nouveau"
      ];

      boot.kernelParams = [
        "amd_iommu=on"
        "vfio-pci.ids=${builtins.concatStringsSep "," ids}"
      ];

    };
}
