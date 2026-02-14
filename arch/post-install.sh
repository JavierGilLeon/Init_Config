#!/bin/bash

set -e

# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


# Install hyprland
cd /tmp
yay -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git hyprwire-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils-git muparser
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all && sudo make install

sudo pacman -S --noconfirm dunst xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland noto-fonts kitty waybar

sudo systemctl --user enable --now hyprpolkitagent.service


# Install dolphin
sudo pacman -S --noconfirm dolphin ark audiocd-kio baloo dolphin-plugins kio-admin kio-gdrive kompare konsole

# Install nerd-font


sed -i "\#$HOME/init-conf/post-install.sh#d" ~/.bashrc



