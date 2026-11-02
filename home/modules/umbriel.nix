{ ... }:

{
  programs.umbriel = {
    enable = true;
    settings = {
      general = {
        mod_key = "Super";
        autostart = [ "noctalia" "kwepaperpicker" ];
      };

      input.focus = {
        follows_mouse = true;
        # Default (true): the window the pointer enters also raises above
        # its neighbors. Leave it, rather than narrowing hover to focus-only.
        hover_raises = true;
      };

      # Defining this table replaces the built-in bind set, so every bind that
      # should stay available is listed here.
      keybinds = {
        # --- Apps and session -------------------------------------------------
        "Mod+Return" = { action = "spawn kitty"; repeat = false; };
        "Mod+Space" = "spawn noctalia msg panel-toggle launcher";
        "Mod+Q" = { action = "window-close"; repeat = false; };
        "Mod+Shift+Q" = { action = "window-kill"; repeat = false; };
        "Mod+Escape" = "session-quit";
        "Mod+Shift+Escape" = {
          action = "shortcuts-inhibit-toggle";
          allow_when_inhibited = true;
          repeat = false;
        };

        # --- Screenshots ------------------------------------------------------
        # Region capture; Noctalia copies to clipboard and saves a PNG
        # (see ./noctalia.nix for format and filename pattern).
        "Mod+Shift+S" = { action = "spawn noctalia msg screenshot-region"; repeat = false; };

        # --- Wallpaper picker ---------------------------------------------------
        "Mod+W" = { action = "spawn kwepaperpicker toggle"; repeat = false; };

        # --- Everyday web shortcuts ---------------------------------------------
        "Mod+B" = { action = "spawn helium"; repeat = false; };
        "Mod+Shift+T" = { action = "spawn helium --app=https://twitch.tv"; repeat = false; };
        "Mod+Y" = { action = "spawn helium --app=https://youtube.com"; repeat = false; };
        "Mod+Shift+X" = { action = "spawn helium --app=https://x.com"; repeat = false; };

        # --- Music ----------------------------------------------------------------
        "Mod+Shift+M" = { action = "spawn kitty spotatui"; repeat = false; };

        # --- Media, volume, brightness ----------------------------------------
        "XF86AudioRaiseVolume" = { action = "spawn noctalia msg volume-up"; allow_when_locked = true; };
        "XF86AudioLowerVolume" = { action = "spawn noctalia msg volume-down"; allow_when_locked = true; };
        "XF86AudioMute" = { action = "spawn noctalia msg volume-mute"; allow_when_locked = true; repeat = false; };
        "XF86AudioPlay" = { action = "spawn noctalia msg media toggle"; allow_when_locked = true; repeat = false; };
        "XF86AudioNext" = { action = "spawn noctalia msg media next"; allow_when_locked = true; };
        "XF86AudioPrev" = { action = "spawn noctalia msg media previous"; allow_when_locked = true; };
        "XF86MonBrightnessUp" = { action = "spawn noctalia msg brightness-up"; allow_when_locked = true; };
        "XF86MonBrightnessDown" = { action = "spawn noctalia msg brightness-down"; allow_when_locked = true; };

        # --- Focus ------------------------------------------------------------
        "Mod+Left" = "window-focus-left";
        "Mod+Down" = "window-focus-down";
        "Mod+Up" = "window-focus-up";
        "Mod+Right" = "window-focus-right";
        "Mod+H" = "window-focus-left";
        "Mod+J" = "window-focus-down";
        "Mod+K" = "window-focus-up";
        "Mod+L" = "window-focus-right";
        "Mod+Tab" = "window-focus-next";
        "Mod+Shift+Tab" = "window-focus-previous";
        "Mod+grave" = { action = "window-focus-last"; repeat = false; };
        "Mod+Ctrl+Left" = "output-focus-left";
        "Mod+Ctrl+Right" = "output-focus-right";
        "Mod+Ctrl+Up" = "output-focus-up";
        "Mod+Ctrl+Down" = "output-focus-down";

        # --- Move windows and columns -----------------------------------------
        "Mod+Shift+Left" = "column-move-left";
        "Mod+Shift+Right" = "column-move-right";
        "Mod+Shift+Up" = "window-move-up";
        "Mod+Shift+Down" = "window-move-down";
        "Mod+Ctrl+Shift+Left" = "column-move-to-output-left";
        "Mod+Ctrl+Shift+Right" = "column-move-to-output-right";
        "Mod+Ctrl+Shift+Up" = "column-move-to-output-up";
        "Mod+Ctrl+Shift+Down" = "column-move-to-output-down";

        # --- Window state -----------------------------------------------------
        "Mod+T" = { action = "window-toggle-floating"; repeat = false; };
        "Mod+Alt+F" = { action = "window-focus-switch-floating"; repeat = false; };
        "Mod+P" = { action = "window-toggle-pinned"; repeat = false; };
        "Mod+F" = { action = "window-toggle-maximize-to-edges"; repeat = false; };
        "Mod+Shift+F" = { action = "window-toggle-fullscreen"; repeat = false; };
        "Mod+M" = { action = "window-toggle-maximize"; repeat = false; };
        # Shrink / expand the focused column.
        "Mod+bracketleft" = "window-modify-primary-extent -0.1";
        "Mod+bracketright" = "window-modify-primary-extent 0.1";
        "Mod+R" = "window-cycle-primary-extent";
        "Mod+Shift+R" = "window-cycle-primary-extent-back";
        "Mod+Comma" = "window-consume-left";
        "Mod+Period" = "window-consume-right";
        "Mod+Ctrl+Comma" = "window-consume-from-left";
        "Mod+Ctrl+Period" = "window-consume-from-right";
        "Mod+Shift+W" = { action = "column-toggle-tabbed"; repeat = false; };
        "Mod+Alt+Right" = "column-focus-tab-next";
        "Mod+Alt+Left" = "column-focus-tab-previous";
        "Mod+D" = { action = "workspace-toggle-show-desktop"; repeat = false; };

        # --- Layout switcher --------------------------------------------------
        # Mod+Alt+Space cycles scrolling -> dwindle -> master -> stacking.
        "Mod+Alt+Space" = { action = "workspace-set-layout toggle"; repeat = false; };
        "Mod+Alt+1" = { action = "workspace-set-layout scrolling"; repeat = false; };
        "Mod+Alt+2" = { action = "workspace-set-layout dwindle"; repeat = false; };
        "Mod+Alt+3" = { action = "workspace-set-layout master"; repeat = false; };
        "Mod+Alt+4" = { action = "workspace-set-layout stacking"; repeat = false; };
        "Mod+Alt+T" = { action = "layout-toggle-split"; repeat = false; };
        "Mod+Alt+Up" = "layout-master-count-increase";
        "Mod+Alt+Down" = "layout-master-count-decrease";

        # --- Workspaces -------------------------------------------------------
        "Mod+1" = "workspace-switch 1";
        "Mod+2" = "workspace-switch 2";
        "Mod+3" = "workspace-switch 3";
        "Mod+4" = "workspace-switch 4";
        "Mod+5" = "workspace-switch 5";
        "Mod+6" = "workspace-switch 6";
        "Mod+7" = "workspace-switch 7";
        "Mod+8" = "workspace-switch 8";
        "Mod+9" = "workspace-switch 9";
        "Mod+Shift+1" = "window-move-to-workspace 1";
        "Mod+Shift+2" = "window-move-to-workspace 2";
        "Mod+Shift+3" = "window-move-to-workspace 3";
        "Mod+Shift+4" = "window-move-to-workspace 4";
        "Mod+Shift+5" = "window-move-to-workspace 5";
        "Mod+Shift+6" = "window-move-to-workspace 6";
        "Mod+Shift+7" = "window-move-to-workspace 7";
        "Mod+Shift+8" = "window-move-to-workspace 8";
        "Mod+Shift+9" = "window-move-to-workspace 9";
        "Mod+Page_Down" = "workspace-next";
        "Mod+Page_Up" = "workspace-previous";
        "Mod+Shift+Page_Down" = "window-move-to-workspace-next";
        "Mod+Shift+Page_Up" = "window-move-to-workspace-previous";
        "Mod+Ctrl+Page_Down" = "workspace-move-to-output-next";
        "Mod+Ctrl+Page_Up" = "workspace-move-to-output-previous";

        # --- Scratchpad -------------------------------------------------------
        "Mod+Shift+Space" = { action = "window-toggle-scratchpad"; repeat = false; };
        "Mod+Ctrl+Space" = { action = "scratchpad-toggle"; repeat = false; };

        # --- Overview and help ------------------------------------------------
        "Mod+O" = { action = "overview-toggle"; repeat = false; };
        "Mod+Slash" = { action = "cheatsheet-toggle"; repeat = false; };

        # --- Pointer ----------------------------------------------------------
        "Mod+WheelUp" = "window-focus-left";
        "Mod+WheelDown" = "window-focus-right";
      };

      # Frosted glass behind the terminal; kitty itself renders at 88% opacity.
      window_rule = [
        {
          match.app_id = "^kitty$";
          blur = true;
          blur_optimized = false;
        }
      ];

      # Highest vendor-advertised refresh rate per monitor (read from live EDID,
      # not guessed). Umbriel falls back to the preferred mode if either fails.
      output."DP-2".mode = "2560x1440@200";
      output."HDMI-A-1".mode = "1920x1080@144";

      # Matugen writes [colors.border] here on every wallpaper change (see
      # ./matugen.nix). Optional + outside the Nix store since config.toml
      # itself is a read-only home-manager symlink; this file isn't.
      include.optional.files = [ "~/.config/umbriel/colors.toml" ];
    };
  };
}
