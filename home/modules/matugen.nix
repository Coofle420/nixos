{ pkgs, lib, ... }:

let
  tomlFormat = pkgs.formats.toml { };

  # matugen's own module turned out to be build-time/static (pre-render once from
  # a nix-pinned wallpaper), not a live runtime engine. Since the ask is "matugen
  # follows the (live, changing) wallpaper colors", we manage matugen's native
  # config.toml directly and invoke the real CLI from Noctalia's wallpaper_changed
  # hook (see ./noctalia.nix) instead.
  matugenConfig = tomlFormat.generate "matugen-config.toml" {
    config = {
      version_check = false;
      # Some wallpapers (incl. the NixOS default) have multiple equally-dominant
      # colors; without a preference matugen demands an interactive prompt, which
      # would hang a non-interactive run from the wallpaper_changed hook.
      fallback_color = "#8a9bbd";
      prefer = "closest-to-fallback";
      caching = true;
    };

    templates = {
      kitty = {
        input_path = "${./templates/kitty.conf}";
        output_path = "/home/user/.config/kitty/colors-matugen.conf";
        type = "SchemeContent";
        post_hook = "${pkgs.procps}/bin/pkill -SIGUSR1 kitty || true";
      };
      gtk3 = {
        input_path = "${./templates/gtk-colors.css}";
        output_path = "/home/user/.config/gtk-3.0/colors-matugen.css";
        type = "SchemeContent";
      };
      gtk4 = {
        input_path = "${./templates/gtk-colors.css}";
        output_path = "/home/user/.config/gtk-4.0/colors-matugen.css";
        type = "SchemeContent";
      };
      btop = {
        input_path = "${./templates/btop.theme}";
        output_path = "/home/user/.config/btop/themes/matugen.theme";
        type = "SchemeContent";
      };
      umbriel = {
        input_path = "${./templates/umbriel-colors.toml}";
        # Outside the Nix store so Umbriel can read it at runtime; wired in via
        # an optional include in ./umbriel.nix (home-manager owns config.toml,
        # matugen owns this one file, merged by Umbriel's include mechanism).
        output_path = "/home/user/.config/umbriel/colors.toml";
        type = "SchemeContent";
      };
      fastfetch = {
        input_path = "${./templates/fastfetch.jsonc}";
        # fastfetch is one-shot (not a daemon) and has no config-merge story,
        # so matugen owns the whole file; ./terminal.nix only installs the
        # package now.
        output_path = "/home/user/.config/fastfetch/config.jsonc";
        type = "SchemeContent";
      };
    };
  };
in
{
  home.packages = [ pkgs.matugen ];

  xdg.configFile."matugen/config.toml".source = matugenConfig;

  gtk = {
    enable = true;

    # adw-gtk3 is the GTK3 theme that actually honors libadwaita-style color
    # variables (@accent_color, @window_bg_color, etc) -- exactly the tokens
    # our matugen template writes. Without a theme that reads them, apps like
    # Steam's (GTK3) file picker stay stock light Adwaita no matter what
    # colors-matugen.css defines.
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    # Noctalia appends its own import to gtk.css at runtime; include it here too
    # so Home Manager's version is complete and Noctalia has no reason to
    # rewrite the file.
    gtk3.extraCss = ''
      @import "colors-matugen.css";
      @import url("noctalia.css");
    '';
    gtk4.extraCss = ''
      @import "colors-matugen.css";
      @import url("noctalia.css");
    '';
  };

  # Populate the generated template outputs immediately on first switch,
  # instead of waiting for the first wallpaper change.
  home.activation.matugenInitialRun = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.matugen}/bin/matugen image --mode dark \
      "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}" || true
  '';
}
