{ ... }:

{
  # Umbriel (Wayland compositor) + Noctalia (shell) are enabled here; the actual
  # module code comes from the umbriel/noctalia flake inputs, imported in flake.nix.
  programs.umbriel.enable = true;
  programs.noctalia.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.enable = false;

  # Disk/filesystem management daemon — used by GNOME Disks, Dolphin's
  # "eject"/mount actions, and similar. Plasma used to pull this in
  # transitively; nothing does now, so it needs to be explicit.
  services.udisks2.enable = true;

  # Secret Service provider (org.freedesktop.secrets) -- neither Umbriel nor
  # Noctalia ships one. Apps like Claude Desktop need this for credential
  # storage. PAM unlocks the login keyring automatically using your SDDM
  # login password, so it's ready as soon as the session starts.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
}
