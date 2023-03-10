{ config, lib, pkgs, ... }:

{
  # Steam is installed as system because of 32 bits issues
  home.packages = with pkgs; [
    prismlauncher
    steamcmd
    steam-tui
    heroic
    lutris
    wine
    gamemode

    # Use parsec to connect to desktop PC while on laptop
    parsec-bin
  ];
}
