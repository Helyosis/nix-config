# Stolen from https://github.com/Harmos274/nixfiles/blob/master/lib/default.nix
{ inputs, overlays }:
{
  mkSystem = { hostname, system, users ? [ ] }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system hostname;
      };
      modules = [
        ../hosts/${hostname}
        {
          networking.hostName = hostname;

          # Allow unfree packages
          nixpkgs = {
            inherit overlays;
            config.allowUnfree = true;
          };

          # Add each input as a registry
          nix.registry = inputs.nixpkgs.lib.mapAttrs'
            (n: v: inputs.nixpkgs.lib.nameValuePair n { flake = v; })
            inputs;
        }
      ] ++ inputs.nixpkgs.lib.forEach users (u: ../users/${u}/system);
    };

  mkHome = { username, system, hostname, stateVersion }:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit system hostname inputs;
        unstable-pkgs = builtins.getAttr system inputs.nixpkgs-unstable.outputs.legacyPackages;
      };
      pkgs = builtins.getAttr system inputs.nixpkgs.outputs.legacyPackages;
      modules = [
        ../users/${username}/home
        {
          nixpkgs = {
            inherit overlays;
            # See: https://github.com/nix-community/home-manager/issues/2942
            config.allowUnfreePredicate = (pkg: true);
          };
          programs = {
            home-manager.enable = true;
            git.enable = true;
          };
          # ???
          systemd.user.startServices = "sd-switch";

          home = {
            inherit username stateVersion;
            homeDirectory = "/home/${username}";
          };
        }
      ];
    };
}
