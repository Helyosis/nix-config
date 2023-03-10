{ config, pkgs, lib, ... }:
let
  my_emacs = (
    (pkgs.emacsPackagesFor pkgs.emacsPgtk).emacsWithPackages (epkgs: [ epkgs.vterm ])
  );
in
{
  # Install Doom Emacs from here: https://github.com/hlissner/doom-emacs

  # Doom configuration
  home.file.".doom.d/".source = ./doom.d;

  # Run Doom Sync when configuration changes or install Doom Emacs if it
  # doesn't exists.
  home.file.".doom.d/".onChange = ''
    if [[ ! -f "$HOME/.emacs.d/bin/doom" ]]
    then
      git clone https://github.com/hlissner/doom-emacs $HOME/.emacs.d
      $HOME/.emacs.d/bin/doom install
    fi
    $HOME/.emacs.d/bin/doom sync
  '';

  services.emacs.enable = true;
  services.emacs.package = my_emacs;

  programs.emacs = {
    enable = true;
    package = my_emacs;
  };

  # Doom Emacs requirements
  home.packages = with pkgs; [
    cmake
    gnumake
    libtool
    fd
    ripgrep
    direnv
    pyright
  ];
}
