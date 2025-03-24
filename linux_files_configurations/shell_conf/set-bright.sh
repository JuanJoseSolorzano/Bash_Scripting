#! /bin/bash

#default values.
install=false
help=false
#Print help 
usage() {
    echo "Usage: $0 [-i <false>] [-h <usage>]" 
    echo " -i -> install the tool needed."
    echo " -h -> print the help"
    echo " Example: set-bright.sh 50 [50% of the screen brights]"; exit 1; 
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
  bright=$(dpkg-query -W -f='${Status}' brightnessctl)
  if [[ $bright == "install ok installed" ]]; then
    echo "[+] >>brightnessctl is already installed."
  else
    echo "[!] >>brightnessctl is not installed."
    sudo apt install brightnessctl 
    sudo cp set-bright.sh /usr/local/bin/
  fi
elif [[ $help == true ]]; then
  usage
fi
}
#main
re='^[0-9]+$' #regex: if the parameter given is a number.
if [[ $1 =~ $re ]]; then #if there is an option as a number
  val=$(($1 * 10))
  brightnessctl s $val 1>/dev/null
elif [[ "${i}" ]] || [ "${h}" ]; then
  usage
else
  _options_ $1
fi

main
