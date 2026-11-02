{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Spotify Connect (Soloist / librespot) needs inbound traffic that the
  # default firewall drops. Without these, the device announces itself on mDNS
  # but never hears a discovery query, so it never appears in any Spotify app.
  #
  #   UDP 5353 - mDNS. Discovery queries arrive here; blocked inbound means the
  #              device is advertised but unreachable, with no error anywhere.
  #   TCP      - the Connect endpoint. Soloist picks a RANDOM port on every
  #              start (no fixed-port option; see spotify/soloist issue #4), so
  #              the ephemeral range is allowed, restricted to the LAN subnet.
  networking.firewall.allowedUDPPorts = [ 5353 ];
  networking.firewall.extraInputRules = ''
    ip saddr 192.168.0.0/24 tcp dport 32768-60999 accept
  '';
}
