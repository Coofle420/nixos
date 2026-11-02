{ lib, ... }:

{
  # The system-level services.flatpak.enable (in /etc/nixos's modules/gaming.nix)
  # only turns on the flatpak portal/D-Bus service -- it's a separate option
  # from this one, which is nix-flatpak's home-manager module and is what
  # actually adds flathub and installs the packages below declaratively.
  services.flatpak.enable = true;

  services.flatpak.packages = [
    "com.discordapp.Discord"
    "com.obsproject.Studio"
    "com.vysp3r.ProtonPlus"
    "com.spotify.Client"
    "org.signal.Signal"
  ];

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };
}
