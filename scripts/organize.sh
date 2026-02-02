#!/bin/bash

USER_HOME="/home/javi"
DOWNLOADS="$USER_HOME/Downloads"



function move_pdf(){
  DEST="$USER_HOME/Documents/pdf"

  mkdir -p "$DEST"

  find "$DOWNLOADS" -maxdepth 1 -type f -iname "*.pdf" -exec mv {} "$DEST" \;
  echo "PDFs organizados" >> "$USER_HOME/Documents/scripts/.organize.log"

}

function move_zip(){
  DEST="$USER_HOME/Documents/zip"

  mkdir -p "$DEST"

  find "$DOWNLOADS" -maxdepth 1 -type f -iname "*.zip" -exec mv {} "$DEST" \;
  find "$DOWNLOADS" -maxdepth 1 -type f -iname "*.tar.gz" -exec mv {} "$DEST" \;
  echo "ZIPs organizados" >> "$USER_HOME/Documents/scripts/.organize.log"
}


function main(){

  echo "$(date): Comenzando Organizacion" >> "$USER_HOME/Documents/scripts/.organize.log"
  move_pdf
  move_zip
  echo "$(date): Organizacion Finalizada" >> "$USER_HOME/Documents/scripts/.organize.log"
}


main
