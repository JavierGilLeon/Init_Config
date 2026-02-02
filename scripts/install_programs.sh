#!/bin/bash


basic(){
  sudo apt install curl zsh wine

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

modify_zshrc(){
  echo 'alias discord="flatpak run com.discordapp.Discord"' >> ~/.zshrc
  echo 'alias teams="flatpak run com.github.IsmaelMartinez.teams_for_linux"' >> ~/.zshrc

  source ~/.zshrc
}

flatpak(){
  sudo apt install flatpak
  flatpak install flathub com.discordapp.Discord # discord
  flatpak install flathub com.github.IsmaelMartinez.teams_for_linux # teams
}

brave(){
  curl -fsS https://dl.brave.com/install.sh | sh
}

steam(){
 cd /tmp
 wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
 sudo apt install ./steam.deb
}

basic
modify_zshrc
flatpak
brave
steam
