#!/bin/bash
#******************************************************************************************************#
# Author: Solorzano, Juan Jose
# Date: 17/04/2025
# Description: This script is used to search for a string pattern in a file and optionally replace it.
# Usage: 
# ./changeString.sh -f <file path> -p <pattern> [options]
# Options:
#   -f, --file <file path>       Specify the file to search in (required).
#   -p, --pattern <pattern>      Specify the string pattern to search for (required).
#   --newLine <string>           Specify the new string to replace the pattern with.
#   --set                        Apply the replacement in the file.
#   -q                           Silence the output (minimal information).
#   -h, --help                   Display this help panel.
#   -v                           Enable verbose mode to display detailed output.
#******************************************************************************************************#

# *ctrl_c* function to handle Ctrl+C
trap ctrl_c INT
function ctrl_c {
  echo "Exiting..."
  exit 1
}

function help_panel {
  echo " "
  printf '%.0s=' {1..80}
  printf "\n[?] -HELP PANEL-\n"
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -f, --file <file path>   Specify the file to search in (required)."
  echo "  -p, --pattern <pattern>  Specify the string pattern to search for (required)."
  echo "  --newLine <string>       Specify the new string to replace the pattern with."
  echo "  --set                    Apply the replacement in the file."
  echo "  -q                       Silence the output (minimal information)."
  echo "  -h, --help               Display this help panel."
  echo ""
  printf '%.0s=' {1..80}
  echo ""
}
# Initialize variables for the options
FILE_PATH=""
PATTERN=""
NEW_LINE=""
SET=false
SILENCE=false

OPTIONS=$(getopt -o f:p:qh --long file:,pattern:,newLine:,set,help -- "$@")
if [ $? -ne 0 ]; then
  echo "Error parsing options"
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
  case "$1" in
    -f|--file)
      FILE_PATH="$2"
      shift 2;;
    -p|--pattern)
      PATTERN="$2"
      shift 2;;
    --newLine)
      NEW_LINE="$2"
      shift 2;;
    --set)
      SET=true
      shift;;
    -q)
      SILENCE=true
      shift;;
    -h|--help)
      help_panel
      exit 0;;
    --)
      shift
      break;;
    *) 
      echo "Invalid option $1"
      exit 1;;
  esac
done

# check the args given:
function check_args {
  if [[ -z "$FILE_PATH" || -z "$PATTERN" ]]; then
    echo "Error: Both File path and String pattern are required."
    help_panel
    exit 1
  fi
  if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found."
    exit 1
  fi
}

function print_info {
  echo "==================================================================================="
  echo " Searching for pattern \"$PATTERN\" in file \"$FILE_PATH\""
  echo " Please wait..."
  echo "-----------------------------------------------------------------------------------"
}

function main {
  pattern_founds=$(cat $FILE_PATH | grep -Fn "$PATTERN")
  if [ -z "$pattern_founds" ]; then
    echo " No pattern \"$PATTERN\" found in the file: \"$FILE_PATH\"."
  else
    if [ "$SILENCE" = false ]; then
      print_info
    fi
    if [ -n "$NEW_LINE" ]; then
      if [ "$SET" = true ]; then
        sed -i "s|$(echo "$PATTERN" | sed 's/[&/\]/\\&/g')|$(echo "$NEW_LINE" | sed 's/[&/\]/\\&/g')|g" "$FILE_PATH"
        if [ "$SILENCE" = false ]; then
          echo " Pattern found and replaced:"
          echo " line=$pattern_founds"
          echo " The new string now is:"
          echo " line=$pattern_founds" | sed "s|$PATTERN|$NEW_LINE|g"
        else
          echo " $(basename $FILE_PATH) - Changed."
        fi
      else
        if [ "$SILENCE" = false ]; then
          echo " The new string will look like this:"
          new_line=$(echo "$pattern_founds" | sed "s|$PATTERN|$NEW_LINE|g")
          echo "$new_line"
          echo "==================================================================================="
        else
          echo " $(basename $FILE_PATH) - Changed."
        fi
      fi
    else 
      echo " Pattern found:"
      echo " line=$pattern_founds "
      echo "==================================================================================="
    fi
  fi
}
#===============================#
# Main script execution
#===============================#
check_args # Check the arguments given by the user
main # Call the main function to start the script