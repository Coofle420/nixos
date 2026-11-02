set -euo pipefail

system=0
if [ "${1:-}" = "-s" ] || [ "${1:-}" = "--system" ]; then
  system=1
  shift
fi

flake="/etc/nixos"

if [ "$system" = 1 ]; then
  file="${flake}/extra-packages.txt"
else
  file="${flake}/home/extra-packages.txt"
fi

usage() {
  cat <<'EOF'
app — manage extra packages

  app add <pkg>...     add user package(s), then rebuild
  app rm <pkg>...       remove user package(s), then rebuild
  app list              show the current user list
  app search <term>     search nixpkgs
  app edit               edit the user list in $EDITOR

  app -s add <pkg>...    add system package(s), then rebuild
  app -s rm <pkg>...      remove system package(s), then rebuild
  app -s list              show the current system list
  app -s edit               edit the system list in $EDITOR

Everything now rebuilds through `sudo nixos-rebuild switch --flake /etc/nixos`
(passwordless). Use -s only for things that truly need to be system-wide
(kernel modules, setuid wrappers, system services) -- almost everything should
just be a plain `app add`.
EOF
}

listed() {
  grep -vE '^[[:space:]]*(#|$)' "$file" 2>/dev/null || true
}

rebuild() {
  sudo nixos-rebuild switch --flake "$flake"
}

remove_line() {
  grep -vxF -- "$1" "$file" > "${file}.tmp" || true
  mv "${file}.tmp" "$file"
}

cmd="${1:-}"
shift || true

case "$cmd" in
  add)
    [ $# -gt 0 ] || { echo "usage: app add <package> [package...]" >&2; exit 1; }
    added=()
    for p in "$@"; do
      if listed | grep -qxF -- "$p"; then
        echo "already listed: $p"
      else
        printf '%s\n' "$p" >> "$file"
        added+=("$p")
      fi
    done
    [ ${#added[@]} -gt 0 ] || exit 0
    if rebuild; then
      echo "added: ${added[*]}"
    else
      echo "switch failed; rolling back: ${added[*]}" >&2
      for p in "${added[@]}"; do remove_line "$p"; done
      exit 1
    fi
    ;;
  rm|remove)
    [ $# -gt 0 ] || { echo "usage: app rm <package> [package...]" >&2; exit 1; }
    for p in "$@"; do
      if listed | grep -qxF -- "$p"; then
        remove_line "$p"
        echo "removed: $p"
      else
        echo "not listed: $p"
      fi
    done
    rebuild
    ;;
  list|ls)
    listed
    ;;
  search)
    [ $# -gt 0 ] || { echo "usage: app search <term>" >&2; exit 1; }
    nix search nixpkgs "$@"
    ;;
  edit)
    "${EDITOR:-nano}" "$file"
    ;;
  *)
    usage
    ;;
esac
