#!/bin/bash

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
