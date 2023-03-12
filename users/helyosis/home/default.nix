{ config, pkgs, unstable-pkgs, inputs, lib, ... }:
{
  imports = [
    ./doom-emacs
    ./custom-fonts
    ./gaming
    ./python.nix
    inputs.homeage.homeManagerModules.homeage
  ];

  # Basic git configuration
  programs.git = {
    enable = true;
    userName = "Aloïs Colléaux-Le Chêne";
    userEmail = "alois.colleaux-le-chene@epita.fr";
    extraConfig = {
      pull.rebase = true;
    };
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
    unstable-pkgs.webcord
    age
    nextcloud-client
    rust-analyzer
    rustc
    cargo
    jdk17
    onlyoffice-bin
    maven
    lombok
    javaPackages.junit_4_12
    jetbrains.idea-ultimate
    jetbrains.clion
    libyamlcpp
    cmake
    qmk
    graphviz
    deluge
    chntpw
    file
    wezterm

    toybox
    (pkgs.lib.hiPrio coreutils-full)
  ];
}
