# Custom Arch + Windows Dual-Boot Features

A collection of custom tweaks and features on this Arch Linux (KDE Plasma) system, which is dual-booted with Windows 11.

## Features

| Feature | Docs |
|---|---|
| Hibernation (swap-partition resume) | [hibernation/](hibernation/) |
| S3 (deep) sleep | [s3-sleep/](s3-sleep/) |
| ctOS boot/shutdown/hibernate sounds | [ctos-sounds/](ctos-sounds/) |
| Oh My Zsh setup | [ohmyzsh/](ohmyzsh/) |
| Custom Plymouth boot theme (watch-dogs) | [plymouth-theme/](plymouth-theme/) |
| GRUB dual-boot (Arch + Windows 11) | [grub-dualboot/](grub-dualboot/) |
| Custom wallpapers | [wallpapers/](wallpapers/) |

## System layout

- `sda1` — EFI/boot (`/boot`), FAT32
- `sda2` — swap (16G)
- `sda3` — Arch root (ext4)
- `sda4` — Windows 11 (NTFS)

## Reproduce

Each subfolder contains a README with the exact config files changed and commands run.
