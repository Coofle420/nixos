{ pkgs, lib, ... }:

let
  # Mirrors ~/nixos/extra-packages.txt, for packages that
  # genuinely need to be system-wide (kernel modules, setuid wrappers, system
  # services). Managed with `app -s add/rm/list`, same as the home-manager one.
  packageNames =
    let
      lines = lib.splitString "\n" (builtins.readFile ../extra-packages.txt);
      names = map (line: lib.trim (builtins.head (lib.splitString "#" line))) lines;
    in
    builtins.filter (name: name != "") names;
in
{
  environment.systemPackages = map (name: lib.getAttrFromPath (lib.splitString "." name) pkgs) packageNames;
}
