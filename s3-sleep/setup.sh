#!/bin/bash
set -e
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=1605ff27-5303-47c9-9831-c098620d98e6 mem_sleep_default=deep"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "Reboot to apply mem_sleep_default=deep"
