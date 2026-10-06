# Hibernation

Hibernation is enabled via the dedicated swap partition (`sda2`, UUID `1605ff27-5303-47c9-9831-c098620d98e6`, 16G).

## Changes

### 1. Kernel cmdline — `/etc/default/grub`
```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=1605ff27-5303-47c9-9831-c098620d98e6 mem_sleep_default=deep"
```
Regenerate after editing:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 2. mkinitcpio — `/etc/mkinitcpio.conf`
`resume` hook added after `plymouth`:
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block plymouth resume filesystems fsck)
```
Rebuild:
```bash
sudo mkinitcpio -P
```

### 3. fstab — `/etc/fstab`
```
UUID=1605ff27-5303-47c9-9831-c098620d98e6	none	swap	defaults	0 0
```

## Test
```bash
systemctl hibernate
```

## Dual-boot notes
- Disable Windows Fast Startup so the shared NTFS partition isn't left in a hibernated/dirty state.
- Don't hibernate while a shared partition is mounted on the other OS.
