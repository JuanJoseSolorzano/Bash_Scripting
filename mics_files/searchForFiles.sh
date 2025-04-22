#!/bin/bash
#******************************************************************************************************#
# Author: Solorzano, Juan Jose
# Date: 17/04/2025
# Description: This script is used to search for files with a specific extension in a given folder.
# Usage: 
# ./searchForFiles.sh -x <extension> -f <folder> [options]
# Options:
#   -x, --extension <extension>  Specify the file extension to search for.
#   -f, --folder <folder>        Specify the folder to search in.
#   --save                       Save the search results to a file.
#   -v                           Enable verbose mode to display detailed output.
#   -s                           Silence mode to suppress folder listing.
#   -h, --help                   Display this help panel.
#******************************************************************************************************#

# *ctrl_c* function to handle Ctrl+C
trap ctrl_c INT
function ctrl_c {
    echo "Exiting..."
    exit 1
}
function help_panel {
    echo "============================================================================"
    echo "[?] -HELP PANEL-"
    echo "Usage: $0 -x <extension> -d <folder> [options]"
    echo "Options:"
    echo "  -x, --extension <extension>  Specify the file extension to search for."
    echo "  -d, --dir <folder>           Specify the folder to search in."
    echo "  --log                        Save the search results to a file."
    echo "  -v                           Enable verbose mode to display detailed output."
    echo "  -s                           Silence mode to suppress folder listing and just show results."
    echo "  -p, --pattern <pattern>      Specify a pattern to search for within the files."
    echo "  -h, --help                   Display this help panel."
    exit 1
}
# Initialize variables for the options
FOLDER=""
EXTENSION=""
EXTENSION_CNT=0
PATTERN_CNT=0
SAVE=false
VERBOSE=false
SILENCE=false
LOG_FILE="search_results.log"
PATTERN=""
PATTERN_FOUND=false
# Manage the arguments: searchForXml.sh <option> <file>
OPTIONS=$(getopt -o x:d:p:vsh --long extension:,dir:,pattern:,log,help, -- "$@")
if [ $? -ne 0 ]; then
    echo "Error parsing options"
    exit 1
fi
# Parse the options
eval set -- "$OPTIONS"
while true; do
    case "$1" in
        -x|--extension)
            EXTENSION="$2"
            shift 2;;
        -d|--dir)
            FOLDER="$2"
            shift 2;;
        --log)
            SAVE=true
            shift;;
        -v)
            VERBOSE=true
            shift;;
        -s)
            SILENCE=true
            shift;;
        -h|--help)
            help_panel
            shift;;
        -p|--pattern)
            PATTERN="$2"
            shift 2;;
        --)
            shift
            break;;
        *)
            echo "Invalid option $1"
            exit 1;;
    esac
done
# Check if the required options are provided
function check_args {
    if [ -z "$EXTENSION" ]; then
        help_panel
        exit 1
    else
        EXTENSION=$(echo "$EXTENSION" | sed 's/\.//') # Remove the dot from the extension (if given)
    fi
    if [ -z "$FOLDER" ]; then
        FOLDER="." # Default to current directory if no folder is specified
    fi
    folder_matches=$(find . -type d -name "$FOLDER")
    if [ -z "$folder_matches" ]; then
        echo "Error: The specified folder does not exist."
        exit 1
    elif [ "$SILENCE" = false ]; then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "Search in folders:"
        if [ "$FOLDER" = "." ]; then
            echo "  - $(pwd)"
        else
            for folder in $folder_matches; do
                echo "  - $folder"
            done
        fi
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    fi
}
# The main function
function main {
    if [ $SILENCE = false ]; then
        echo " Searching for files with extension \"$EXTENSION\" and pattern \"$PATTERN\" in folder \"$FOLDER\""
        echo "-----------------------------------------------------------------------------"
    fi
    files_with_extension=()
    files_with_pattern=()
    
    for folder in $folder_matches; do
        files_found=$(find "$folder" -type f -name "*.$EXTENSION")
        # Review the files found.
        for file in $files_found; do
            if [ "" != "$PATTERN" ]; then
                if grep -qi "$PATTERN" "$file" 2>/dev/null; then
                    files_with_pattern+=("$file")
                    PATTERN_CNT=$((PATTERN_CNT +1))
                    PATTERN_FOUND=true
                else
                    PATTERN_FOUND=false
                fi
            fi
            files_with_extension+=("$file")
            EXTENSION_CNT=$((EXTENSION_CNT + 1))
            # show the output results to the console
            if [ "$VERBOSE" = true ]; then
                if [ "" != "$PATTERN" ]; then
                    echo "$file - Pattern found: $PATTERN_FOUND"
                else
                    echo "$file"
                fi
            fi
        done
        #
        if [ "$SILENCE" = false ]; then
            if [ "$FOLDER" = "." ]; then
                folder=$(pwd)
            fi
            echo " Found at: $folder"
            echo " >> $EXTENSION_CNT with extension $EXTENSION"
            echo " >> $PATTERN_CNT with pattern $PATTERN"
            echo "-----------------------------------------------------------------------------"
        fi
    done

    if [ "$SILENCE" == true ]; then
        if [ "" != "$PATTERN" ]; then
            echo "${files_with_pattern[@]}"
        else
            echo "${files_with_extension[@]}"
        fi
        return
    fi
    if [ "$SAVE" = true ]; then
        if [ -f "$LOG_FILE" ]; then
            # Remove the old log file if it exists
            rm -f "$LOG_FILE"
        fi
        if [ "" != "$PATTERN" ]; then
            LOG_FILE_PATTERN="${LOG_FILE%.*}_$PATTERN.log"
            if [ -f "$LOG_FILE_PATTERN" ]; then
                # Remove the old log file if it exists
                rm -f "$LOG_FILE_PATTERN"
            fi
            for file in "${files_with_pattern[@]}"; do
                echo "$file" >> "$LOG_FILE_PATTERN"
            done
        fi  
        for file in "${files_with_extension[@]}"; do
            echo "$file" >> "$LOG_FILE"
        done
        echo "Saved results at: $(dirname "$LOG_FILE")/$(basename "$LOG_FILE")"
    else
        echo "Total files found: $EXTENSION_CNT"
    fi
}
#=========================================
# Main code flow
#=========================================
check_args # Check the arguments given by the user
main # Call the main function to start the script