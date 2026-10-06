# GRUB Dual-Boot (Arch + Windows 11)

Arch installed alongside Windows 11 on one NVMe/SATA disk; GRUB + os-prober boot manager. Keywords: arch linux windows 11 dual boot grub, os-prober not detecting windows.

## Partition layout (this machine — KDE Plasma / ext4 / no LUKS)
| Partition | Usage |
|---|---|
| `sda1` | EFI System Partition (`/boot`), FAT32 |
| `sda2` | swap, 16G |
| `sda3` | Arch root (`/`), ext4 |
| `sda4` | Windows 11, NTFS |

## `/etc/default/grub` highlights
```bash
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=1605ff27-... mem_sleep_default=deep"
GRUB_CMDLINE_LINUX="rootfstype=ext4 quiet splash"
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
GRUB_DISABLE_OS_PROBER=false
```

## Regenerate
- Arch: `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- Ubuntu: same command (GRUB is on EFI partition too).
- Fedora: edits via `grubby` or `/etc/default/grub` then `grub2-mkconfig -o /boot/grub2/grub.cfg`.

## Conditions
- `os-prober` package must be installed for Windows to appear (Arch: `pacman -S os-prober`).
- Windows must be **fully shut down** (not hibernated/fast-startup) for os-prober to see it and avoid NTFS issues.
- EFI entries under `/boot/EFI/` (`BOOT`, `GRUB`, `Microsoft`) must exist and the UEFI boot order set with `efibootmgr`.

## Limitations
- Secure Boot: shim/mok not configured here — enable Secure Boot will require signed GRUB (`shim` on Ubuntu/Fedora handles it; bare Arch needs manual signing).
