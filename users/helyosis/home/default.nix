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

  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerdfonts
    cm_unicode

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

    (lib.setPrio 100 toybox) # Toybox looks to be outdated for many bins, we want it to have the lowest priority, to fill in any missing programs that do not need specifics features
    coreutils-full
    netcat-gnu
  ];
}
