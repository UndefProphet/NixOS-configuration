{
  description = "Classic Bar";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];

    perSystem = { inputs', self', pkgs, ... }: {
      packages.quickshell =
        (inputs'.qml-niri.packages.quickshell.override {
         withWayland = true;
         withPipewire = true;
         withQtSvg = true;
         withJemalloc = true;
         withNetworkManager = false;
         withPolkit = false;
         withHyprland = false;
         withPam = false;
         withX11 = false;
         withI3 = false;
         }).overrideAttrs
      { doCheck = false; };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          self'.packages.quickshell
          typescript-language-server
          kdePackages.qtdeclarative
        ];

        shellHook = # bash
          ''
          [ ! -f .qmlls.ini ] && touch src/.qmlls.ini
          alias quickshell="quickshell -p $PWD/src"
          '';
      };
    };
  };

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    quickshell = {
      type = "git";
      url = "https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qml-niri = {
      type = "github";
      owner = "imiric";
      repo = "qml-niri";
      ref = "main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
  };
}
