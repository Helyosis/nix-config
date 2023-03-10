{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix-community.nix
    ./gaming.nix
  ];

  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    xorg.xhost
  ];
}
