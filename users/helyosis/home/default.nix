{ config, pkgs, inputs, ... }:
{
  imports = [
    ./doom-emacs
    ./custom-fonts
    ./gaming
    inputs.homeage.homeManagerModules.homeage
  ];

  # Basic git configuration
  programs.git = {
    enable = true;
    userName = "Aloïs Colléaux-Le Chêne";
    userEmail = "alois.colleaux-le-chene@epita.fr";
  };

  # Manage secrets through Homeage (https://github.com/jordanisaacs/homeage)
  homeage = {
    # Absolute path to identity (created not through home-manager)
    identityPaths = [ "~/.ssh/id_rsa" ];

    # "activation" if system doesn't support systemd
    installationType = "systemd";

     # file."nextcloud" = {
       # Path to encrypted file tracked by the git repository
       # source = ./secrets/netrc.age;
       # symlinks = [ "~/.netrc" ];
       # copies = [ "${config.xdg.configHome}/no-symlink-support/secretkey.json" ];
     # };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerdfonts
    firefox
    webcord
    age
    nextcloud-client
    python310
    rust-analyzer
    rustc
    cargo
  ];
}
