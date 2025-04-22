#!/bin/bash
#=================================================================================================#
# Author: Solorzano, Juan Jose.
# Date: 04/04/2025
# Description: This script modifies the XML files to include the correct path for the pattern given.
# Usage: ./changeLine.sh <file> <pattern>
# Example: ./changeLine.sh noRepeatedLines.txt 'my_pattern'
# Dependencies: searchForFiles.sh, searchForPattern.sh, changeString.sh
#=================================================================================================#

CURR_DIR=$(pwd)
NOT_FOUND=3
FOUND=0
# Manage the exit of the script
trap ctrl_c INT
function ctrl_c {
    echo "Exiting..."
    echo "$NOT_FOUND files not found"
    echo "$FOUND files modified"
    exit 1
}

# Search for cnfPar files in the .tex files
#for cnfPar in $(ls target_folder); do 
#    grep "$pattern" "target_folder/$cnfPar" | 
#    sed -e 's/<\/\?$pattern>//g' | 
#    tr -d ' ' >> allFilesFound.txt
#done
#sort allFilesFound.txt | uniq > noRepeatedLines.txt

# for files found at cnf folder
#fileName=$(./searchForFiles.sh -x "xml" -d "cnf" --log)

file="$1"
pattern="$2"
if [[ -z "$file" ]]; then
    echo "Usage: $0 <file>"
    echo "[?] The file should contain a list of xml files to be modified."
    echo "Example: $0 noRepeatedLines.txt"
    exit 1
fi
# main function
function change {
    printf '%.0s+' {1..80}"" >> log.txt
    printf "\n CHANGE LINE LOG.\n" >> log.txt
    file="$1" # gets the user input
    for path in $(cat "$file");do
        path=$(echo "$path" | sed 's/\.\///') # remove the ./ from the path
        pattern_path="$(./searchForPattern.sh -f $path -p "$pattern" --exclude "?>")" # Returns the raw path.
        current_pattern="$(grep "$pattern" "$path")" # Returns the sps path including the <?altova_sps string.
        cd "$(dirname $path)" # change to the directory of the file
        if [[ -e "$pattern_path" ]]; then # If the sps path was created correctly using './searchForSps.sh', then we can proceed.
            success=true
            status="Changed"
        else
            success=false
            status="Error"
        fi
        cd "$CURR_DIR" # change back to the original directory
        if [[ "$success" == true ]]; then
            ./changeString.sh -f "$path" -p "$current_sps" --newLine "<?$pattern $pattern_path?>" -q --set # change the current sps path to the new one.
            FOUND=$((FOUND + 1))
        else
            echo "Errors in:" >> log.txt
            echo "$path" >> log.txt
            NOT_FOUND=$((NOT_FOUND + 1))
        fi
        echo "$path - $status" >> log.txt
    done
    printf '%.0s+' {1..80}
    printf "\n[?] -RESULTS-\n"
    echo "  $NOT_FOUND files not found"
    echo "  $NOT_FOUND files not found" >> log.txt
    echo "  $FOUND files modified" >> log.txt
    echo "  $FOUND files modified"
    printf '%.0s+' {1..80}
    echo ""
}
# call the main function
change "$file"
