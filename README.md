# Arch Linux Dual-Boot Custom Tweaks

Custom tweaks and features for a PC dual-booted with **Arch Linux (KDE Plasma)** and **Windows 11** — hibernation, S3 deep sleep, ctOS boot/shutdown sounds, custom Plymouth theme, Oh My Zsh, GRUB setup. Applicable guides for **Arch, Ubuntu, and Fedora** are included in each section.

## Features

| Feature | Docs | Keywords |
|---|---|---|
| Hibernation (swap-partition resume) | [hibernation/](hibernation/) | arch linux hibernate, linux doesn't resume from hibernate, add hibernate to power menu |
| S3 (deep) sleep | [s3-sleep/](s3-sleep/) | linux mem_sleep_default=deep, S3 vs s2idle |
| ctOS sounds | [ctos-sounds/](ctos-sounds/) | linux startup sound, shutdown sound systemd |
| Oh My Zsh | [ohmyzsh/](ohmyzsh/) | ohmyzsh theme plugins arch |
| Plymouth theme | [plymouth-theme/](plymouth-theme/) | arch plymouth theme boot splash |
| GRUB dual boot | [grub-dualboot/](grub-dualboot/) | arch windows 11 dual boot grub |

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
