#!/bin/bash

echo -n "Enter EFI size: "
read EFI

echo -n "Enter SWAP size: "
read SWAP

echo "label: gpt" >> partition.dump
echo "start=2048, size=$EFI, type=uefi" >> partition.dump
echo "size=$SWAP, type=swap" >> partition.dump
echo "type=linux" >> partition.dump

SDA=0
VDA=0

(ls /dev/ | grep sda ) && SDA=1
(ls /dev/ | grep vda ) && VDA=1

if [SDA]; then 
  sfdisk /dev/sda < partition.dump
elif [VDA]; then
  sfdisk /dev/vda < partition.dump
else
  echo "Disk not detected"
fi

