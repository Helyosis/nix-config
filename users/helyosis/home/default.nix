{ config, pkgs, unstable-pkgs, ... }:
{

  # Basic git configuration
  programs.git = {
    enable = true;
    userName = "Aloïs Colléaux-Le Chêne";
    userEmail = "alois.colleaux-le-chene@epita.fr";
  };

  home.packages = with pkgs; [
  ];
}
