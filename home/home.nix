# ─────────────────────────────────────────────────────────────────────────────
# Home Manager — entry point
#
# Everyday use:
#   app add <name>     install an app (and rebuild)
#   app rm <name>      uninstall it
#   app search <term>  find package names
#   hme                edit this file / extra-packages.txt
#   hms                rebuild after manual edits
#
# Where things go:
#   1. A plain app              → `app add <name>` (writes extra-packages.txt)
#   2. An app with settings     → `programs.<name>` here, or its own file in
#                                 modules/ listed in `imports` below
#   3. A flatpak                → modules/flatpaks.nix
#   4. Desktop / compositor     → modules/umbriel.nix, noctalia.nix, matugen.nix
#   5. Terminal, shell, prompt  → modules/terminal.nix, shell.nix
#
# Undo a rebuild: home-manager generations → home-manager switch --rollback
# ─────────────────────────────────────────────────────────────────────────────

{ pkgs, lib, ... }:

let
  # One package per line, `#` starts a comment. Managed by `app add` / `app rm`.
  packageNames =
    let
      lines = lib.splitString "\n" (builtins.readFile ./extra-packages.txt);
      names = map (line: lib.trim (builtins.head (lib.splitString "#" line))) lines;
    in
    builtins.filter (name: name != "") names;

  extraPackages = map (name: lib.getAttrFromPath (lib.splitString "." name) pkgs) packageNames;
in

{
  # ── Identity ───────────────────────────────────────────────────────────────
  # home.username / home.homeDirectory are set by the NixOS Home Manager module.
  home.stateVersion = "26.05";

  # Rebuild the font cache on every switch. Without this, fonts added to the
  # profile (Material Symbols for kwepaperpicker, Nerd Fonts) stay invisible to
  # fontconfig until someone runs fc-cache by hand.
  fonts.fontconfig.enable = true;

  # ── Extra packages ─────────────────────────────────────────────────────────
  # Comes from extra-packages.txt; use `app add` / `app rm` rather than editing
  # Nix. Everything here lands in the profile and, for GUI apps, the launcher.
  home.packages = extraPackages;

  # ── Programs that need a setting ───────────────────────────────────────────
  # Short toggles are fine right here. Bigger setups live in modules/.
  #
  # programs.htop.enable = true;
  # programs.btop.enable = true;

  # ── Modules ────────────────────────────────────────────────────────────────
  imports = [
    # Desktop: compositor, shell, wallpaper theming
    ./modules/umbriel.nix
    ./modules/noctalia.nix
    ./modules/matugen.nix
    ./modules/kwepaperpicker.nix

    # Apps
    ./modules/apps.nix
    ./modules/terminal.nix
    ./modules/shell.nix
    ./modules/helium.nix
    ./modules/claude-desktop.nix
    ./modules/spotifast.nix
    ./modules/spotatui.nix

    # Games
    ./modules/games.nix

    # Declarative flatpaks
    ./modules/flatpaks.nix
  ];
}
