# GRUB Dual-Boot (Arch + Windows 11)

GRUB is the bootloader; OS prober detects Windows 11 on `sda4`.

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
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

`/boot` is the EFI System Partition (`sda1`, `4A14-960F`). Relevant grub.d entries: `10_linux`, `30_os-prober`, `30_uefi-firmware`, `31_efi_bootnext`.
