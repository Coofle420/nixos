{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nix-settings.nix
    ./modules/boot.nix
    ./modules/graphics.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/audio.nix
    ./modules/users.nix
    ./modules/desktop.nix
    ./modules/gaming.nix
    ./modules/sudo.nix
    ./modules/extra-packages.nix
    ./modules/nix-ld.nix
  ];

  # Set on first install; do not change (see configuration.nix(5) / nixos manual).
  system.stateVersion = "26.05";
}
