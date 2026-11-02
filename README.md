# NixOS + Home Manager

One flake, one rebuild. The operating system and the user environment live
together here.

```
flake.nix               inputs + nixosConfigurations.nixos
configuration.nix       system entry point
modules/                system modules (boot, graphics, networking, users, ...)
home/home.nix           Home Manager entry point
home/modules/           user modules (apps, terminal, shell, desktop, ...)
home/templates/         matugen templates
extra-packages.txt      system-wide extra packages
home/extra-packages.txt user extra packages
```

## Rebuild

Anything under this directory needs a rebuild:

```sh
cd /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos
```

`nrs` is the fish abbreviation for exactly that. There is no separate
`home-manager switch` any more — Home Manager is a NixOS module here.

Rollback: `sudo nixos-rebuild --rollback switch`, or pick an older generation
in the systemd-boot menu.

## Add an app

```sh
app add mpv            # user package  -> home/extra-packages.txt
app add jq tree        # several at once
app rm mpv
app list
app search <term>      # find package names
app edit               # edit the list by hand

app -s add <pkg>       # system package -> extra-packages.txt
```

Both variants run the rebuild for you (nixos-rebuild is passwordless here).
Use `-s` only for things that genuinely need to be system-wide: kernel
modules, setuid wrappers, system services.

## Where to edit

| What | File |
| --- | --- |
| Packages, imports | `home/home.nix` |
| Kitty + fastfetch | `home/modules/terminal.nix` |
| Fish, starship, zoxide, direnv | `home/modules/shell.nix` |
| Firefox, git, dev tools, dolphin | `home/modules/apps.nix` |
| Games and launchers | `home/modules/games.nix` |
| Flatpaks | `home/modules/flatpaks.nix` |
| Umbriel keybinds | `home/modules/umbriel.nix` |
| Noctalia / wallpaper | `home/modules/noctalia.nix` |
| Matugen | `home/modules/matugen.nix` |
| Theme templates | `home/modules/templates/` |
| Kernel, boot, graphics, networking | `modules/` |

`hme` opens `home/home.nix` in `$EDITOR`.

## When a rebuild fails

- The error usually names the option; check `home-manager option` or the NixOS
  manual.
- A file "would be clobbered": Home Manager renames it to `*.hm-backup` and
  continues (`home-manager.backupFileExtension`).
- The previous generation is still bootable, so a failed switch never leaves
  you stranded.
