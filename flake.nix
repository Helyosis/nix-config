{
  description = "Helyosis' NixOS configuation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs:
    let
      local-overlays = import ./overlays;
      overlays = with inputs;
        [
          (import emacs-overlay)
          local-overlays
        ];
      lib = import ./lib { inherit inputs overlays; };
    in
    {
      nixosConfigurations = {
        xps = lib.mkSystem {
          hostname = "xps";
          system = "x86_64-linux";
          users = [ "helyosis" ];
        };
      };
      homeConfigurations = {
        "helyosis@xps" = lib.mkHome {
          username = "helyosis";
          system = "x86_64-linux";
          hostname = "xps";
          stateVersion = "22.11";
        };
      };

    } // inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import inputs.nixpkgs { inherit system overlays; };
        in
        {
          # If you're not using NixOS and only want to load your home
          # configuration when `nix` is installed on your system and
          # flakes are enabled.
          #
          # Enable a `nix develop` shell with home-manager and git to
          # only load your home configuration.
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [ home-manager git ];
            NIX_CONFIG = "experimental-features = nix-command flakes";
          };
        }
      );
}
