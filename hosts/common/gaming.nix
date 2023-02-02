{ config, pkgs, lib, ... }: {
  # We use flatpak for steam because it is way too buggy else.
  services.flatpak.enable = true;
}
