# Hibernation on Arch / Ubuntu / Fedora

How to enable hibernation (suspend-to-disk) with a dedicated swap partition. Keywords: arch linux hibernate, linux not resuming from hibernate, add hibernate to power menu, gnome hibernate button missing.

## Conditions
- Swap must be **>= RAM size** (this machine: 16G swap vs ~8G RAM).
- On this dual-boot setup, swap is a separate partition (`sda2`). A swap file also works if given a higher priority and correct `resume_offset` (btrfs excluded here).
- Secure Boot not covered.

## 1. Kernel resume parameter
Append to kernel cmdline:
```
resume=UUID=1605ff27-5303-47c9-9831-c098620d98e6
```
Use `UUID=$(blkid -s UUID -o value /dev/sda2)` to find yours.

- **Arch / Ubuntu** (GRUB): set in `/etc/default/grub`:
  ```
  GRUB_CMDLINE_LINUX_DEFAULT="resume=<UUID> ..."
  sudo grub-mkconfig -o /boot/grub/grub.cfg   # Ubuntu: /boot/grub/grub.cfg
  ```
- **Fedora** (BLS): use `grubby --update-kernel=ALL --args="resume=UUID=<UUID>"` (no grub-mkconfig).

## 2. Initramfs resume hook
- **Arch (mkinitcpio):** add `resume` to `HOOKS` in `/etc/mkinitcpio.conf`:
  ```
  HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block plymouth resume filesystems fsck)
  ```
  Then: `sudo mkinitcpio -P`
- **Ubuntu (initramfs-tools):** create `/etc/initramfs-tools/conf.d/resume`:
  ```
  RESUME=UUID=<UUID>
  ```
  Then: `sudo update-initramfs -u`
- **Fedora (dracut):** usually automatic if resume= is on the cmdline; for LUKS you may need `dracut --regenerate-all --force`.

## 3. fstab
```
UUID=1605ff27-5303-47c9-9831-c098620d98e6  none  swap  defaults  0 0
```

## Show Hibernate in the power menu
- **KDE Plasma:** appears automatically once logind reports `CanHibernate = yes` (check: `gdbus call --system --dest org.freedesktop.login1 --object-path /org/freedesktop/login1 --method org.freedesktop.login1.Manager.CanHibernate`).
- **GNOME:** not built in — install the "Hibernate Status Button" GNOME Shell extension.
- **Any DE:** `systemctl hibernate`.

## Test
```bash
systemctl hibernate
```

## Limitations
- Never hibernate while the Windows NTFS partition (`sda4`) is mounted, and disable Windows Fast Startup so Windows itself isn't in a hibernated state at the same time.
- If resume fails, your session is lost — check `journalctl -b` for `PM: hibernation` messages.
