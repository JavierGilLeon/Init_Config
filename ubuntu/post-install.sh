#!/usr/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y openssh-server
sudo systemctl enable --now openssh-server



# Install Nerd Font
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DepartureMono.zip

if ! command -v unzip >/dev/null; then
  echo "unzip is not installed. Installing..."
  sudo apt install -y unzip
fi

unzip DepartureMono.zip -d departuremono
cd departuremono
mv DepartureMono* ~/.local/share/fonts/
fc-cache -f -v

reboot
