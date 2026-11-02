{ pkgs, ... }:

{
  # Lets dynamically-linked binaries built for generic (FHS) Linux distros
  # run on NixOS without being Nix-patched -- needed for things like Claude
  # Desktop's bundled Claude Code CLI, VS Code extensions' native binaries,
  # downloaded language-server executables, etc. See nix.dev/permalink/stub-ld.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    curl
    icu
  ];
}
