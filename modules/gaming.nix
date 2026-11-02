{ ... }:

{
  # System-level pieces that genuinely need setuid wrappers / system services.
  # The declarative list of games/launchers lives in Home Manager.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  programs.gamemode.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;
}
