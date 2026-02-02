#!/bin/bash

# Script that returns the current server status


function memory_check(){
  echo ""
  echo "The current memory usage is: "
  free -h
  echo ""
}

function disk_check(){
  echo ""
  echo "The current disk usage is: "
  df -k / 
  echo ""
}

function cpu_check(){
  echo ""
  echo "The current cpu usage is: "
  cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{print ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}'
  echo ""
}


function kernel_check(){
  echo ""
  echo "The kernel version is: "
  uname -r
  echo ""
}


memory_check
disk_check
cpu_check
kernel_check
