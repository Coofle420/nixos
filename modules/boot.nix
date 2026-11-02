{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # CachyOS kernel (LTO+BORE variant), provided by the chaotic-nyx flake input.
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
