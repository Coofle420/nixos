{ pkgs, ... }:

{
  # programs.steam.enable (setuid wrappers, firewall rules) lives in the system
  # flake's modules/gaming.nix. This is just the user-level companion tooling.
  home.packages = with pkgs; [
    protonup-qt
    mangohud
    gamescope
    lutris
    heroic
  ];
}
