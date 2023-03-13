{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    pwninit
    wireshark
  ];
}
