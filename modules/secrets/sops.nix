{ inputs, ... }: {

  tack.inputs = {
    # You may not have these!
    fetch.nixos-credentials = "git+ssh://git@github.com/UndefProphet/.nixos.credentials?ref=hjem-move";

    # https://github.com/Mic92/sops-nix
    # Atomic, declarative, and reproducible secret provisioning for NixOS based on sops.
    sops-nix = "gh:Mic92/sops-nix?ref=master";
  };

  flake.modules.nixos.secrets =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ]
      ++ (lib.optional (inputs ? nixos-credentials) "${inputs.nixos-credentials}/secrets.nix");

      # Sops config
      sops = {
        defaultSopsFile = ./secrets/master.yaml;
        defaultSopsFormat = "yaml";
        age.keyFile = "${config.hj.xdg.config}/.config/sops/age/keys.txt";
      };
    };
}
