#!/bin/bash
set -e
sudo cp ctos-sound /usr/local/bin/
sudo chmod +x /usr/local/bin/ctos-sound
sudo mkdir -p /usr/share/sounds/ctos
sudo cp ctos-shutdown.ogg /usr/share/sounds/ctos/
mkdir -p ~/.local/share/sounds
cp ctos-boot.ogg ~/.local/share/sounds/
sudo cp ctos-hibernate-on.service ctos-hibernate-off.service ctos-sound-shutdown.service /etc/systemd/system/
mkdir -p ~/.config/systemd/user
cp ctos-boot-sound.service ~/.config/systemd/user/
sudo systemctl enable ctos-hibernate-on.service ctos-hibernate-off.service ctos-sound-shutdown.service
systemctl --user enable ctos-boot-sound.service
echo "Done."
