{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.helyosis = {
    isNormalUser = true;
    home = "/home/helyosis";
    description = "Helyosis";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
