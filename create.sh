#!/bin/bash

set -e

EFI_SIZE_MB=1024
RAM_SIZE_KB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
RAM_SIZE_MB=$((RAM_SIZE_KB / 1024))

if   [ "$RAM_SIZE_MB" -le 4096 ];  then
  SWAP_MB=$((RAM_SIZE_MB*2))
elif [ "$RAM_SIZE_MB" -le 8192 ];  then
  SWAP_MB=$((RAM_SIZE_MB))
elif [ "$RAM_SIZE_MB" -le 16384 ]; then
  SWAP_MB=8192
else
  SWAP_MB=4096
fi


cat > partition.dump << EOF
label: gpt
start=2048, size=${EFI_SIZE_MB}M, type=uefi
size=${SWAP_MB}M, type=swap
type=linux
EOF

if   [ -b /dev/sda ]; then
  DISK=/dev/sda
elif [ -b /dev/vda ]; then
  DISK=/dev/vda
else
  echo "Disk not found"
  exit 1
fi

sfdisk "$DISK" < partition.dump
