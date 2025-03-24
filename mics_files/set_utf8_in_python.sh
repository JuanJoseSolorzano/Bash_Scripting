#!/bin/bash
#====================================================================#
# Author: Solorzano, Juan Jose                                       #
# Purpose: set the UTF-8 encoding in multiple python scripts.        #
# Date:                                                              # 
#--------------------------------------------------------------------#
# Usage:                                                             #
# $ bash set_utf8_in_python.sh <folder_name>                         #
# Example:                                                           #
# $ bash set_utf8_in_python.sh /home/user/Scripts                    #
#                                                                    #
# Note:                                                              #
# The script will search for all python scripts in the specified     #
# folder and set the UTF-8 encoding in the first line of each script.#
# If the encoding is already defined, the script will skip the file. #
#====================================================================#

function getScriptsName {
    # Returns a string with the find command result
    folderName="$1" # assigning an identifier.
    find "$folderName" -type f -name "*.py" #return
}

function setUTF {
    # Set the string into the script.
    pathList="$1"  # assigning an identifier.
    for path in $pathList; do
        utfString=$(grep "coding: UTF-8" "$path")
        if [[ -n $utfString ]]; then # if encoding definition exists, do nothing.
            echo "UTF coding exists -> $path"
        else
            echo "Modified -> $path"
            sed -i '1s/^/# -*- coding: UTF-8 -*-\n/' "$path"
        fi
    done
}

#main
if [ -z "$1" ]; then # if empty parameter
    echo "[!] What's the folder name ?"
else
    scriptList=$(getScriptsName "$1")
    if ! [[ -z $scriptList ]]; then
        setUTF "$scriptList"
    else
        echo "[!] No Python scripts found in the specified folder"
    fi
fi
