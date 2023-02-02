{ config, lib, pkgs, ... }:

{
  # Steam is installed as system because of 32 bits issues
  home.packages = with pkgs; [
    prismlauncher
  ];
}
