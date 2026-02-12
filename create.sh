#!/bin/bash

set -e


EFI_SIZE_MB=1024
SWAP_SIZE_MB=16384

first_steps(){
  read -p "User: " user_id
  echo
  read -p -s "User password: " user_passwd

  echo "$user_password" | useradd "$user_id"

  if [ $? -eq 0]; then
    echo "User $user_id added successfully"
  else
    echo "Failed to add user $user_id"
    first_steps()
  fi
}

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
    [Yy]*) sfdisk "$DISK" < partition.dump ;;

    [Nn]*)
	 read -p "EFI size in MB: " EFI_SIZE_MB
	 read -p "SWAP size in MB: " SWAP_SIZE_MB
	 make_partition $EFI_SIZE_MB $SWAP_SIZE_MB ;;
  esac

  if [ "$yn" == "" ]; then
    sfdisk "$DISK" < partition.dump
  fi
}

mount_partition(){
  EFI=$(sfdisk -l "$DISK" | grep -i "efi")
  EFI_DISK=$(echo "$EFI" | awk '{print $1}')

  SWAP=$(sfdisk -l "$DISK" | grep -i "swap")
  SWAP_DISK=$(echo "$SWAP" | awk '{print $1}')

  LINUX=$(sfdisk -l "$DISK" | grep -i "filesystem")
  LINUX_DISK=$(echo "$LINUX" | awk '{print $1}')
  
  mkfs.ext4 "$LINUX_DISK"
  mkswap "$SWAP_DISK"
  mkfs.fat -F 32 "$EFI_DISK"

  mount "$LINUX_DISK" /mnt
  mount --mkdir "$EFI_DISK" /mnt/boot
  swapon "$SWAP_DISK"

}

install_essential_packages(){
  pacstrap -K /mnt base linux linux-firmware
}

configure_system(){
  genfstab -U /mnt >> /mnt/etc/fstab
}


if   [ -b /dev/sda ]; then # -b -> file exists and is a block special file
  DISK=/dev/sda
elif [ -b /dev/vda ]; then
  DISK=/dev/vda
else
  echo "Disk not found"
  exit 1
fi

make_partition $EFI_SIZE_MB $SWAP_SIZE_MB
mount_partition
install_essential_packages
configure_system
