{ pkgs, ... }:

{
  programs.fish.enable = true;

  users.users."user" = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  services.printing.enable = true;
}
