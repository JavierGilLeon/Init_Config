#!/bin/bash


basic(){
  sudo apt install curl zsh wine build-essential libssl-dev make ninja cargo tar

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


}

#-----------------------------------------------------------------------------
modify_zshrc(){
  echo 'alias discord="flatpak run com.discordapp.Discord"' >> ~/.zshrc
  echo 'alias teams="flatpak run com.github.IsmaelMartinez.teams_for_linux"' >> ~/.zshrc

  source ~/.zshrc
}

#-----------------------------------------------------------------------------
flatpak(){
  sudo apt install flatpak
  flatpak install flathub com.discordapp.Discord # discord
  flatpak install flathub com.github.IsmaelMartinez.teams_for_linux # teams
}

#-----------------------------------------------------------------------------
brave(){
  curl -fsS https://dl.brave.com/install.sh | sh
}

#-----------------------------------------------------------------------------
steam(){
 wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
 sudo apt install ./steam.deb
}

#-----------------------------------------------------------------------------
install_cmake(){
  CMAKE_TAG=$(curl -s https://api.github.com/repos/Kitware/CMake/tags | grep -m1 '"name": "v' | sed -E 's/.*"name": "([^"]+)".*/\1/')

CMAKE_VERSION="${CMAKE_TAG#v}"

curl -fLO --progress-bar "https://github.com/Kitware/CMake/releases/download/$CMAKE_TAG/cmake-$CMAKE_VERSION.tar.gz"

tar -xzf cmake-*.tar.gz

cd cmake-*

./bootstrap

make -j"$(nproc)"

sudo make install
}

#-----------------------------------------------------------------------------
install_torrent(){
  git clone https://github.com/qbittorrent/qBittorrent.git torrent
  cd torrent

  mkdir -p build && cd build

  cmake ..
  make 
}

#-----------------------------------------------------------------------------
install_fastfetch(){
git clone https://github.com/fastfetch-cli/fastfetch.git fastfetch
cd fastfetch
mkdir -p build
cd build
cmake ..
cmake --build . --target fastfetch

}

#-----------------------------------------------------------------------------
basic
flatpak

cd /tmp
brave
steam
install_cmake
install_torrent
install_fastfetch

cd ~
modify_zshrc

clear
fastfetch
