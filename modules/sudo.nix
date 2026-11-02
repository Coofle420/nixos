{ ... }:

{
  # Only nixos-rebuild skips the password (what `nrs`/`app -s add` run).
  # Every other sudo command still prompts normally.
  security.sudo.extraRules = [
    {
      users = [ "user" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
