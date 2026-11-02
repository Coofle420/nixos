# Example only. Replace this file with the output of `nixos-generate-config`
# for your own machine; the real one contains disk UUIDs.
{ lib, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
