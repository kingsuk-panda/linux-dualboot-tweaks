# Plymouth Theme

Custom boot splash with the `watch-dogs` theme. Keywords: arch plymouth watch-dogs, change plymouth theme ubuntu fedora.

## Config — `/etc/plymouth/plymouthd.conf`
```ini
[Daemon]
Theme=watch-dogs
```

Theme files: `/usr/share/plymouth/themes/watch-dogs/` (`watch-dogs.script`, `bootanimation/`).

## Prerequisites
- `plymouth` package installed (Arch: `pacman -S plymouth`, Ubuntu: `apt install plymouth`, Fedora: `dnf install plymouth`).
- Kernel cmdline contains `quiet splash`.
- mkinitcpio includes `plymouth` hook (Arch): `HOOKS=(... plymouth resume filesystems ...)`; rebuild with `sudo mkinitcpio -P`.
  - Ubuntu: `update-initramfs -u`
  - Fedora: `dracut --regenerate-all --force`

## Switch theme
```bash
plymouth-set-default-theme watch-dogs
# or edit /etc/plymouth/plymouthd.conf and rebuild initramfs
```
List available: `plymouth-set-default-theme --list`.

## Limitations
- Requires a graphical boot environment; Plymouth does not render under Hyper-V/SSH/serial.
- If the theme fails to load, system falls back to the `spinner`/text theme.
