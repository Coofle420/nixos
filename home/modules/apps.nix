{ pkgs, ... }:

{
  # ── Browser ────────────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── Git ────────────────────────────────────────────────────────────────────
  programs.git.enable = true;

  # ── Apps without settings of their own ─────────────────────────────────────
  home.packages = (with pkgs; [
    # dev tools
    wget
    opencode
    claude-code
    neovim 
    gnome-disk-utility
    discord
    # `app` — add/remove packages from extra-packages.txt and rebuild
    (writeShellScriptBin "app" (builtins.readFile ../scripts/app.sh))
  ]) ++ [
    # file manager
    pkgs.kdePackages.dolphin
  ];

  # ── Qt / KDE theming ───────────────────────────────────────────────────────
  # Dolphin and other KDE apps read ~/.config/kdeglobals, which Noctalia
  # regenerates from the wallpaper. Without the KDE platform theme they ignore
  # it and fall back to Qt's light default palette.
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "Breeze";
  };

  # ── File manager defaults ──────────────────────────────────────────────────
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";

      # Already in ~/.config/mimeapps.list before Home Manager owned it.
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";

      # Default browser.
      "text/html" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
    };
  };
}
