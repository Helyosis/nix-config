{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.helyosis = {
    isNormalUser = true;
    home = "/home/helyosis";
    description = "Helyosis";
    extraGroups = [ "networkmanager" "wheel" "tss" "docker" ];
    uid = 1000; # We pin the uids for reproducability (and also to reference them)
  };

  services.udev.extraRules = builtins.readFile ./50-qmk.rules;
}
