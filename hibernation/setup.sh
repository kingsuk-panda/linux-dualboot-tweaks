#!/bin/bash
# Install hibernation setup (Arch only; see README.md for Ubuntu/Fedora).
set -e
UUID=$(blkid -s UUID -o value /dev/sda2)  # swap partition
echo "Swap UUID: $UUID"
sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet resume=UUID=$UUID mem_sleep_default=deep\"|" /etc/default/grub
sudo cp mkinitcpio.conf /etc/mkinitcpio.conf
grep -q "$UUID" /etc/fstab || echo "UUID=$UUID none swap defaults 0 0" | sudo tee -a /etc/fstab
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -P
echo "Done. Reboot and run: systemctl hibernate"
