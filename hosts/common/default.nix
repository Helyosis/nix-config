{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix-community.nix
    ./gaming.nix
  ];
}
