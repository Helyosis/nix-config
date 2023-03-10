# secure-boot.nix stolen from (https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/secure-boot.nix)
# Requires lanzaboote flake
{ lib, config, pkgs, ... }: {
  boot.loader.efi.canTouchEfiVariables = true;

  # Quiet boot with plymouth - supports LUKS passphrase entry if needed
  boot.kernelParams = [
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "boot.shell_on_fail"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;

  # Bootspec and Secure Boot using lanzaboote
  #
  # This throws a bootspec RFC warning - proceed with caution. May need to clear existing /boot entries first:
  # sudo rm -rf /boot/*
  #
  # Commands for reference:
  # sudo sbctl create-keys             # Should be persisted, default is in /etc/secureboot. will not overwrite existing keys
  # sudo sbctl verify                  # Will show warning for any files that will cause lockup while Secure Boot is enabled
  # sudo bootctl status                # View current boot status
  # sudo sbctl enroll-keys --microsoft # Add your SB keys to UEFI - must be in Secure Boot setup mode to enroll keys
  #
  # Most importantly, review this document:
  # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  #
  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
