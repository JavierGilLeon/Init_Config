#!/bin/bash

set -e # Stops if something fails

make_partition(){
  cat > partition.dump << EOF
  label: gpt
  start=2048, size=$1M, type=uefi, name="EFI System Partition"
  size=$2M, type=swap, name="Linux Swap"
  type=linux, name="Linux FileSystem"
EOF

  sfdisk --no-act "$DISK" < partition.dump

  read -p "Write changes to disk? [y/n]: " yn

  case $yn in
    [Yy]*)
      echo "-------------------------------------------"
      echo "Making partitions..."
      echo "-------------------------------------------"
      sfdisk "$DISK" < partition.dump ;;

    [Nn]*)
	 read -p "EFI size in MB: " EFI_SIZE_MB
	 read -p "SWAP size in MB: " SWAP_SIZE_MB
	 make_partition $EFI_SIZE_MB $SWAP_SIZE_MB ;;
  esac

  if [ "$yn" == "" ]; then
  echo "-------------------------------------------"
  echo "Making partitions..."
    sfdisk "$DISK" < partition.dump
  echo "-------------------------------------------"
  fi
}

#-----------------------------------------------------------------
#-----------------------------------------------------------------
#-----------------------------------------------------------------

if [ -d /sys/firmware/efi/efivars ]; then
  echo "-------------------------------------------"
  echo "EFI detected, instalation is about to begin"
  echo "-------------------------------------------"
else
  echo "-------------------------------------------"
  echo "EFI not detected, please start in UEFI mode"
  echo "-------------------------------------------"
  exit 1
fi

EFI_SIZE_MB=1024
SWAP_SIZE_MB=16384

read -p "User: " user_id
echo
read -s -p "User password: " user_passwd
echo

if   [ -b /dev/sda ]; then # -b -> file exists and is a block special file
  DISK=/dev/sda
elif [ -b /dev/vda ]; then
  DISK=/dev/vda
elif [ -b /dev/nvme0n1 ]; then
  DISK=/dev/nvme0n1
else
  echo "-------------------------------------------"
  echo "Disk not found"
  echo "-------------------------------------------"
  exit 1
fi

echo "-------------------------------------------"
echo "Disk detected: ${DISK}"
echo "-------------------------------------------"


make_partition $EFI_SIZE_MB $SWAP_SIZE_MB

if [[ "$DISK" == *"nvme"* ]]; then
  PREFIX="${DISK}p"
else
  PREFIX="${DISK}"
fi


EFI_DISK="${PREFIX}1"
SWAP_DISK="${PREFIX}2"
LINUX_DISK="${PREFIX}3"

echo "-------------------------------------------"
echo "Mounting EFI in ${EFI_DISK}..."
echo "-------------------------------------------"
echo
echo "-------------------------------------------"
echo "Mounting SWAP in ${SWAP_DISK}..."
echo "-------------------------------------------"
echo
echo "-------------------------------------------"
echo "Mounting Linxux FileSystem in ${LINUX_DISK}..."
echo "-------------------------------------------"



mkfs.ext4 "$LINUX_DISK"
mkswap "$SWAP_DISK"
mkfs.fat -F 32 "$EFI_DISK"

mount "$LINUX_DISK" /mnt
mount --mkdir "$EFI_DISK" /mnt/boot
swapon "$SWAP_DISK"


pacstrap -K /mnt base linux linux-firmware git



# Generate FSTAB file
genfstab -U /mnt >> /mnt/etc/fstab


# Chroot into the new system
arch-chroot /mnt /bin/bash << EOF
# Set Time Zone
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

# Generate locales
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Keyboard Layout
echo "KEYMAP=es" > /etc/vconsole.conf

# Hostname
echo "laptop-hp" > /etc/hostname

# Create User
useradd -m -G wheel -s /bin/bash "$user_id"
echo "$user_id:$user_passwd" | chpasswd
echo "root:$user_passwd" | chpasswd

# Enable wheel group to sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Install bootloader (GRUB)
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Clone Install repository
HOME="/home/$user_id"
git clone https://github.com/JavierGilLeon/Init_Config.git "\$HOME/init-conf"
chown -R "$user_id:$user_id" "\$HOME/init-conf"

# Install packages
pacman -S --noconfirm \$(grep -v '^#' \$HOME/init-conf/pre-install-pkg.txt)

# Enable systemd services
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable bluetooth

# Install yay

chmod +x "\$HOME/init-conf/post-install.sh"
echo "\$HOME/init-conf/post-install.sh" >> /home/$user_id/.bashrc

EOF




