# Plymouth Theme

Custom boot splash with the `watch-dogs` theme. Keywords: arch plymouth watch-dogs, change plymouth theme ubuntu fedora.

## Preview

![Watch Dogs Plymouth boot animation](watchdogs-boot.gif)

[▶ Watch the boot animation video (MP4)](watchdogs-boot.mp4)

> GitHub strips inline `<video>`/`<audio>` tags from README files, so the animation is embedded as an inline GIF and the MP4 is linked for browser playback. Click the link to play the video on GitHub (raw-URL audio/video links play natively in your browser).
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

## Bundled files
- `plymouthd.conf` → `/etc/plymouth/plymouthd.conf`
- `watch-dogs/` → `/usr/share/plymouth/themes/`
