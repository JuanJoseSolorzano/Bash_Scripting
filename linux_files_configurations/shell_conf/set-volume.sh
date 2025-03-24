#! /bin/bash

#default values.
install=false
help=false
#Print help 
usage() {
    echo "Usage: $0 [-i <false>] [-p <string>]" 1>&2; exit 1; 
}

#process command options.
_options_(){
  while [[ $# -gt 0 ]]; do
    case $1 in
      -i | --install)
        install=true
        shift
        ;;
      -h | --help)
        help=true
        shift
        ;;
    esac
  done
}

main(){
#Installation.
if [[ $install == true  ]]; then
  audio=$(dpkg-query -W -f='${Status}' pulsemixer)
  if [[ $audio == "install ok installed" ]]; then
    echo "[+] >>Pulsemixer is already installed."
  else
    echo "[!] >>Pulsemixer is not installed."
    sudo apt install pulsemixer
    sudo cp set-volume.sh /usr/local/bin/
  fi
elif [[ $help == true ]]; then
  usage
fi
}
#main
re='^[0-9]+$' #regex: if the parameter given is a number.
if [[ $1 =~ $re ]]; then #if there is an option as a number
  pulsemixer --set-volume $1
elif [[ "${i}" ]] || [ "${h}" ]; then
  usage
else
  _options_ $1
fi

main
