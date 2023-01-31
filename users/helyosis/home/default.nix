{ config, pkgs, unstable-pkgs, ... }:
{
  imports = [
    ./doom-emacs
    ./custom-fonts
  ];

  # Basic git configuration
  programs.git = {
    enable = true;
    userName = "Aloïs Colléaux-Le Chêne";
    userEmail = "alois.colleaux-le-chene@epita.fr";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerdfonts
    firefox
    webcord
  ];
}
