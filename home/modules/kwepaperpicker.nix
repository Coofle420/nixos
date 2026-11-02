{ pkgs, config, ... }:

{
  # install.sh's package step only knows pacman/apt/dnf, so its deps are
  # declared here instead of running it. matugen itself is already installed
  # via ./matugen.nix.
  home.packages = with pkgs; [
    quickshell
    material-symbols
    ffmpeg
    curl
    python3
    qt6.qtmultimedia
    qt6.qtimageformats

    # home.sessionPath only reaches login shells, not the systemd --user
    # environment Umbriel's "spawn" and autostart actually use -- so the
    # launcher has to land in the Nix profile (~/.nix-profile/bin), which is
    # already on that PATH. A thin exec shim rather than embedding the real
    # script's contents, so `git pull` takes effect immediately, no rebuild
    # (and flakes can't read an absolute path outside the flake in pure eval).
    (writeShellScriptBin "kwepaperpicker" ''
      exec /home/user/qs-kwepaperpicker/bin/kwepaperpicker "$@"
    '')
  ];

  # The picker stays a live git clone at ~/qs-kwepaperpicker (not Nix-store
  # managed) so `git pull` keeps working, per its own update instructions.
  # This just symlinks it to the path it expects to run from.
  home.file.".config/kwepaperpicker".source =
    config.lib.file.mkOutOfStoreSymlink "/home/user/qs-kwepaperpicker";
}
