{ config, lib, pkgs, ... }:

{
  home.packages = [
    (pkgs.python3.withPackages (p: with p; [
    ]))
  ];
}
