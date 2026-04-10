#!/usr/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y $(grep -v '^#' ~/init-conf/ubuntu/post-install-pkg.txt)


if ! command -v sshd > /dev/null; then
  echo "openssh-server is not installed. Installing..."
  sudo apt install -y openssh-server
fi

sudo systemctl enable --now openssh-server


# Install Nerd Font
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DepartureMono.zip

if ! command -v unzip >/dev/null; then
  echo "unzip is not installed. Installing..."
  sudo apt install -y unzip
fi


if [! -d ~/.local/share/fonts]; then
  mkdir -p ~/.local/share/fonts
fi

unzip DepartureMono.zip -d departuremono
mv /tmp/departuremono/DepartureMono* ~/.local/share/fonts
fc-cache -f -v


# Fastfetch Config
cd /tmp
git clone --depth 1 https://github.com/ImageMagick/ImageMagick.git ~/ImageMagick
cd ~/ImageMagick
./configure --with-modules
make -j$(nproc)
make check
sudo make install

if [! -a /usr/local/bin/magick ]; then
  echo "magick has not installed, please install manually"
else
  sudo ldconfig /usr/local/lib
fi




reboot
