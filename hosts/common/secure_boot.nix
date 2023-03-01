# secure-boot.nix stolen from (https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/secure-boot.nix)
# Requires lanzaboote flake
{ lib, config, pkgs, ... }: {
  boot.loader.efi.canTouchEfiVariables = true;

  # Quiet boot with plymouth - supports LUKS passphrase entry if needed
  boot.kernelParams = [
    "quiet"
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

  # TPM for unlocking LUKS
  #
  # TPM kernel module must be enabled for initrd. Device driver is viewable via the command:
  # sudo systemd-cryptenroll --tpm2-device=list
  # And added to a device's configuration:
  boot.initrd.kernelModules = [ "tpm_crb" ];
  boot.initrd.availableKernelModules = [ "tpm_crb" ];
  #
  # Must be enabled by hand - e.g.
  # sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3 --tpm2-device=auto --tpm2-pcrs=0+2+7
  #
  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  # No swap is configured at present :(
  #services.logind = {
  #  lidSwitch = "suspend-then-hibernate";
  #  extraConfig = ''
  #    HandlePowerKey=suspend-then-hibernate
  #    IdleAction=suspend-then-hibernate
  #    IdleActionSec=2m
  #  '';
  #};
  #systemd.sleep.extraConfig = "HibernateDelaySec=30min";

}
