#!/bin/bash
#******************************************************************************************************#
# Author: Solorzano, Juan Jose
# Date: 17/04/2025
# Description: This script is used to search for a string pattern in a file and return the relative path.
# Usage:
# ./searchForSps.sh -p <pattern> -f <file path> [options]
# Options:
#   -p, --pattern <pattern>     Specify the string pattern to search for (required).
#   -f, --file <file path>     Specify the file to search in (required).
#   --exclude <string>         Specify a string to exclude from the result.
#   -h, --help                 Display this help panel.
#******************************************************************************************************#

# *ctrl_c* function to handle Ctrl+C
trap ctrl_c INT
function ctrl_c {
    echo "Exiting..."
    exit 1
}

function help_panel {
    printf '%.0s-' {1..50}
    printf "\n[?] -HELP PANEL-\n"
    echo "  Usage: $0 -p <pattern> -f <file> [options]"
    echo "  Options:"
    echo "    -p, --pattern   Specify the pattern to search for."
    echo "    -f, --file      Specify the file to search in."
    echo "    --exclude       Specify a string to exclude from the result."
    echo "    -h, --help      Display this help panel."
}
# Initize global variables
PATTERN=""
FILE=""
EXCLUDE=""
CURR_DIR=$(pwd)
# Manage the arguments: searchForXml.sh <option> <file>
OPTIONS=$(getopt -o p:f:h --long pattern:,file:,exclude:,help -- "$@")
if [ $? -ne 0 ]; then
    echo "Error parsing options"
    exit 1
fi
eval set -- "$OPTIONS"
while true; do
    case "$1" in
        -p|--pattern)
            PATTERN="$2"
            shift 2;;
        -f|--file)
            FILE="$2"
            shift 2;;
        --exclude)
            EXCLUDE="$2"
            shift 2;;
        -h|--help)
            help_panel
            shift;;
        --)
            shift
            break;;
        *)
            echo "Invalid option $1"
            exit 1;;
    esac
done

function GetSpsPath {
    pattern_found=$(cat "$FILE" | grep "$PATTERN") 
    matches=$(echo "$pattern_found" | wc -l)
    if [[ $matches > 1 ]]; then
        return 1
    fi
    if [[ -n $pattern_found ]]; then
        file_name=$(basename "$pattern_found")
        file_name=$(echo "$file_name" | sed "s|$EXCLUDE||g") 
        file_location=$(find . -type f -name "$file_name" | head -n 1) # gets only the first match
        file_location=$(echo "$file_location" | sed "s|./||") # remove the ./ from the path string
        root_path=$CURR_DIR/$file_location
        if [[ -f "$root_path" ]]; then
            echo "$root_path"
        fi
    fi
}

function main {
    file_path=$(echo "$FILE" | sed 's|\\|/|g') # Convert backslashes to forward slashes
    sps_path=$(GetSpsPath)
    if [[ -z "$sps_path" ]]; then
        echo "Error: Ambiguous path. Please specify a more specific pattern."
        echo "$sps_path"
        return 1
    fi
    back_count=$(echo "$file_path" | awk '{print $2}' FS="/ta/" | awk '{print NF-1}' FS='/')
    rel_path=$(echo "$sps_path" | awk '{print $2}' FS="ta/")
    relative_path=$(echo "$rel_path" | awk -F'/' "{for(i=1;i<=$back_count;i++) printf \"../\"} {print $NF}")
    echo "$relative_path"
}

function checkArgs {
    if [[ -z "$PATTERN" || -z "$FILE" ]]; then
        echo "Error: Missing required arguments."
        help_panel
        exit 1
    fi
    if [[ ! -f "$FILE" ]]; then
        echo "Error: File $FILE does not exist."
        exit 1
    fi
}

checkArgs
main