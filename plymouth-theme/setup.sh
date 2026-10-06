#!/bin/bash
set -e
sudo cp -r watch-dogs /usr/share/plymouth/themes/
sudo cp plymouthd.conf /etc/plymouth/plymouthd.conf
sudo mkinitcpio -P
grep -q 'splash' /etc/default/grub || sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/& splash/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "Done. Reboot to see it."
