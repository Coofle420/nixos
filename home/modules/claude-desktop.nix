{ claudeDesktopPackage, ... }:

{
  # Third-party packaging, not in nixpkgs (see flake.nix for provenance notes).
  home.packages = [ claudeDesktopPackage ];
}
