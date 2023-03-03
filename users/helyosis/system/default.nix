{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.helyosis = {
    isNormalUser = true;
    home = "/home/helyosis";
    description = "Helyosis";
    extraGroups = [ "networkmanager" "wheel" "tss" ];
    uid = 1000; # We pin the uids for reproducability (and also to reference them)
  };

  services.udev.extraRules = builtins.readFile ./50-qmk.rules;

  # Enable NTFS to read Windows partitions
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/windows" =
    {
      device = "/dev/nvme0n1p4";
      fsType = "ntfs3";
      options = [ "rw" "uid=${builtins.toString config.users.users.helyosis.uid}"];
    };

}
