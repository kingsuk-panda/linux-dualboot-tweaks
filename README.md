# Linux Hibernation, Suspend (S3 deep sleep) & Dual-Boot Tweaks

A practical, tested guide to **hibernating a Linux PC/laptop**, enabling **S3 deep sleep**, adding **Hibernate to the power menu** (KDE, GNOME, XFCE), fixing *"hibernate is not working / not resuming / session lost"*, plus custom ctOS boot/shutdown sounds, Plymouth boot themes, Oh My Zsh, and GRUB dual-boot with Windows 11. Covers **Arch Linux, Ubuntu, and Fedora**.

## Features

| Feature | Docs | Keywords |
|---|---|---|
| Hibernation (swap partition, resuming sessions) | [hibernation/](hibernation/) | arch linux hibernate, linux doesn't resume from hibernate, enable hibernate linux, hibernate to disk, suspend to disk linux, hibernate option not showing, gnome hibernate button missing, add hibernate to power menu, hibernate fails, cannot hibernate linux, linux hibernate windows dual boot |
| S3 deep sleep | [s3-sleep/](s3-sleep/) | linux mem_sleep_default=deep, S3 vs s2idle, sleep not waking linux, s3 sleep not working |
| ctOS sounds | [ctos-sounds/](ctos-sounds/) | linux startup sound, linux shutdown sound systemd, no boot sound linux |
| Oh My Zsh | [ohmyzsh/](ohmyzsh/) | ohmyzsh theme plugins arch ubuntu fedora |
| Plymouth theme | [plymouth-theme/](plymouth-theme/) | arch plymouth watch-dogs, change plymouth boot splash ubuntu fedora |
| GRUB dual boot | [grub-dualboot/](grub-dualboot/) | arch linux windows 11 dual boot grub, os-prober not detecting windows |

## Quick answer: How do I hibernate my Linux laptop?

![Project desktop with custom theme](pictures/desktop-setup.png)

1. Create swap ≥ RAM (partition or file) and note its UUID (`blkid`).
2. Add `resume=UUID=<uuid>` to the kernel command line (GRUB/grubby per distro).
3. Add the `resume` initramfs hook and rebuild (`mkinitcpio -P` / `update-initramfs -u` / `dracut`).
4. Make sure swap is in `/etc/fstab`.
5. Run `systemctl hibernate`.

Full guide with commands and troubleshooting: [hibernation/README.md](hibernation/README.md).

## FAQ

**Hibernate shows up but the machine does not resume previous session.** Check `resume=` in `/proc/cmdline` and `journalctl -b | grep -i hibernate`.

**Hibernate missing from GNOME power menu.** Install the *Hibernate Status Button* GNOME Shell extension. In KDE it appears automatically when logind says `CanHibernate = yes`.

**My swap is a file on btrfs / LVM — does the simple guide work?** Not directly; a swap file needs `resume_offset` and btrfs swap files are restricted. Prefer a dedicated swap partition as done here.

**Can I hibernate with Windows 11 Fast Startup on?** No — disable Fast Startup in Windows, or never mount the Windows NTFS partition from the hibernated Linux session.

**s2idle instead of deep sleep / wake on lid issues.** Set `mem_sleep_default=deep`; see [s3-sleep](s3-sleep/).


## System specifications (this machine)

- **OS:** Arch Linux (rolling), kernel `7.2.8-arch1-2`, x86_64
- **Desktop:** KDE Plasma (X11/Wayland)
- **CPU:** Intel Core i3-6006U @ 2.00GHz
- **GPU:** Intel HD Graphics 520 (Skylake-U GT2)
- **Audio:** Intel Sunrise Point-LP HD Audio
- **RAM:** 7.6 GiB
- **Disks:**
  - `sda1` — EFI/boot (`/boot`), FAT32
  - `sda2` — swap (16G)
  - `sda3` — Arch root (`/`), ext4, 98G
  - `sda4` — Windows 11, NTFS
- **Laptop/desktop power:** S3 deep sleep supported (`/sys/power/mem_sleep` → `s2idle [deep]`)

## Limitations & conditions

- Hibernation requires swap **≥ RAM size** (16G here, ~8G RAM). Hibernating with less swap will fail or truncate.
- With Windows Fast Startup **enabled**, do not mount the NTFS Windows partition from Linux — it will be left hibernated/dirty and may corrupt. Disable Fast Startup in Windows.
- Secure Boot is not covered; signing kernels/modules is out of scope.
- Desktop environment matters for the power menu:
  - **KDE Plasma:** hibernate/suspend actions appear automatically when logind reports them as supported.
  - **GNOME:** install the [Hibernate Status Button](https://extensions.gnome.org/) extension for a Hibernate entry in the power menu.
  - **XFCE/others:** use `systemctl hibernate` or a custom launcher.
- `ctos-sounds` depends on PipeWire/WirePlumber and the `pw-play` binary; on PulseAudio-only systems use `paplay` instead.
