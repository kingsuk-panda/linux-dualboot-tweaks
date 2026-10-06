# Plymouth Theme

Boot splash uses the `watch-dogs` Plymouth theme instead of the default.

## Config — `/etc/plymouth/plymouthd.conf`
```ini
[Daemon]
Theme=watch-dogs
```

Theme directory: `/usr/share/plymouth/themes/watch-dogs/` (`watch-dogs.script`, `bootanimation/`).

## Related
- `plymouth` hook is present in `/etc/mkinitcpio.conf` `HOOKS`.
- Kernel boots with `quiet splash` in `GRUB_CMDLINE_LINUX_DEFAULT`.
