{ spotatuiPackage, ... }:

let
  # Upstream's default package leaves out two opt-in features:
  #   mcp-server - lets an agent (opencode, Claude Code) drive the player via
  #                `spotatui mcp`. Stays inert unless behavior.mcp_enabled is true.
  #   ai-dj      - the in-TUI DJ screen on Ctrl+J. Excluded from default because
  #                it egresses to an LLM provider; here it is driven by the
  #                `opencode` agent CLI already logged in on this machine.
  #   cover-art  - renders album art in the TUI (G) and exposes the Lua
  #                cover_art widget. Pulls image + colorgrad + ratatui-image.
  #   soloist    - Spotify's own headless player as an alternative engine behind
  #                the Connect device (lossless, and the fix for accounts librespot
  #                cannot get audio keys for). Runtime opt-in via
  #                behavior.playback_engine; needs Premium + an API key.
  # None of these are in upstream's default feature set.
  spotatuiWithMcp = spotatuiPackage.overrideAttrs (old: {
    cargoBuildFlags = (old.cargoBuildFlags or [ ]) ++ [
      "--features"
      "mcp-server,ai-dj,cover-art,soloist"
    ];
  });
in
{
  # Third-party packaging, not in nixpkgs (see flake.nix for provenance notes).
  home.packages = [ spotatuiWithMcp ];
}
