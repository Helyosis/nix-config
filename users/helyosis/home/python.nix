{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    sageWithDoc
    (python3.withPackages (p: with p; [
    ]))
  ];
}
