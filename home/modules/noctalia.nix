{ pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
      };

      wallpaper = {
        enabled = true;
        directory = "~/Pictures/Wallpapers";
        default.path = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
      };

      shell.screenshot = {
        save_to_file = true;
        directory = "";
        filename_pattern = "screenshot_%Y%m%d_%H%M%S";
        format = "png";
        copy_to_clipboard = true;
      };

      # Matugen is the authority for every app Noctalia doesn't natively theme
      # (kitty/gtk/qt/btop, see ./matugen.nix) — regenerate on every wallpaper change.
      hooks.wallpaper_changed = "matugen image --mode dark \"$NOCTALIA_WALLPAPER_PATH\"";
    };
  };
}
