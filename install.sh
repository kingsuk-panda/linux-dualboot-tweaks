#!/usr/bin/env bash
# tweakctl installer — works on ANY Linux distro that has python3.
#
#   curl -fsSL https://raw.githubusercontent.com/kingsuk-panda/linux-hibernate-dual-boot-tweaks/main/install.sh | bash
#
# Options:
#   --system      install to /usr/local/bin instead of ~/.local/bin
#   --uninstall   remove tweakctl
#
set -euo pipefail

REPO="kingsuk-panda/linux-hibernate-dual-boot-tweaks"
RAW_BASE="https://raw.githubusercontent.com/$REPO/main"
DEST="$HOME/.local/bin"
UNINSTALL=0

for arg in "$@"; do
  case "$arg" in
    --system)     DEST="/usr/local/bin" ;;
    --uninstall)  UNINSTALL=1 ;;
    -h|--help)    sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

if [ "$UNINSTALL" = 1 ]; then
  found=0
  for d in "$HOME/.local/bin" /usr/local/bin; do
    for f in tweakctl tweakctl-gui; do
      if [ -e "$d/$f" ]; then
        rm -f "$d/$f" 2>/dev/null || sudo rm -f "$d/$f"
        echo "Removed $d/$f"
        found=1
      fi
    done
  done
  [ "$found" = 1 ] || echo "tweakctl is not installed."
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but not installed. Install it with your package manager:" >&2
  echo "  Arch/Manjaro : sudo pacman -S python" >&2
  echo "  Debian/Ubuntu: sudo apt install python3" >&2
  echo "  Fedora/RHEL  : sudo dnf install python3" >&2
  exit 1
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
download() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    echo "curl or wget is required to download tweakctl." >&2; exit 1
  fi
}

download "$RAW_BASE/tweakctl/tweakctl" "$tmp"
if ! head -1 "$tmp" | grep -q '^#!/usr/bin/env python3'; then
  echo "Download failed — got something that is not tweakctl." >&2; exit 1
fi
if ! mkdir -p "$DEST" 2>/dev/null; then
  sudo mkdir -p "$DEST"
fi
if [ -w "$DEST" ]; then
  install -m 755 "$tmp" "$DEST/tweakctl"
else
  sudo install -m 755 "$tmp" "$DEST/tweakctl"
fi

tmp2="$(mktemp)"
download "$RAW_BASE/tweakctl/tweakctl-gui" "$tmp2"
if ! head -1 "$tmp2" | grep -q '^#!/usr/bin/env python3'; then
  echo "Download failed — got something that is not tweakctl-gui." >&2; exit 1
fi
if [ -w "$DEST" ]; then
  install -m 755 "$tmp2" "$DEST/tweakctl-gui"
else
  sudo install -m 755 "$tmp2" "$DEST/tweakctl-gui"
fi

ver="$("$DEST/tweakctl" --version 2>/dev/null || echo '?')"
echo "Installed tweakctl $ver -> $DEST/tweakctl (+ tweakctl-gui)"
case ":$PATH:" in
  *":$DEST:"*) ;;
  *)
    echo "NOTE: $DEST is not in your PATH yet. Add it:"
    echo "      echo 'export PATH=\"$DEST:\$PATH\"' >> ~/.bashrc && . ~/.bashrc"
    ;;
esac
echo
echo "Run 'tweakctl' for the menu, or 'tweakctl --help' for the commands."
