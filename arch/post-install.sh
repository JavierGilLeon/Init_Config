#!/bin/bash

set -e

echo "-------------------------------------"
echo "Installing yay..."
echo "-------------------------------------"

cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo "-------------------------------------"
echo "yay Successfully installed"
echo "-------------------------------------"

echo "-------------------------------------"
echo "Installing Hyprland..."
echo "-------------------------------------"
cd /tmp
yay -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git hyprwire-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils-git muparser
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all && sudo make install

sudo pacman -S --noconfirm dunst xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland noto-fonts kitty waybar

sudo systemctl --user enable --now hyprpolkitagent.service

echo "-------------------------------------"
echo "Hyprland Successfully installed"
echo "-------------------------------------"

echo "-------------------------------------"
echo "Installing Dolphin File Manager..."
echo "-------------------------------------"

sudo pacman -S --noconfirm dolphin ark audiocd-kio baloo dolphin-plugins kio-admin kio-gdrive kompare konsole

echo "-------------------------------------"
echo "Dolphin File Manager Successfully installed"
echo "-------------------------------------"


echo "-------------------------------------"
echo "Installing SDDM greeter..."
echo "-------------------------------------"

sudo pacman -S --noconfirm qt5-base qt5-declarative qt5-tools sddm


echo "-------------------------------------"
echo "SDDM greeter successfully installed"
echo "-------------------------------------"


sed -i "\#$HOME/init-conf/post-install.sh#d" ~/.bashrc



