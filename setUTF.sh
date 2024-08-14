#!/bin/bash
#--------------------------------------------------------------------#
# Author: Solorzano, Juan Jose                                       #
# Propuse: set the UTF-8 encoding in a multply python scripts.       #
# Date:                                                              # 
#--------------------------------------------------------------------#

function getScriptsName {
    # Returns a string with the find command result
    folderName=$1 # assigning a identifier.
    echo "$(find . | grep -i $folderName | grep ".py")" #return
}

function setUTF {
    # Set the string into the script.
    pathList=$1
    for path in $pathList; do
        utfString=$(grep "coding: UTF-8" $path)
        if ! [[ -z $utfString ]]; then # if encoding definition exist, do nothing.
            echo "UTF coding exists -> $path"
        else
            echo "Modified -> $path"
            sed -i '1s/^/# -*- coding: UTF-8 -*-\n/' $path
        fi
        done
}
#main
if [ -z $1 ]; then # if empty parameter
    echo "[!] What's the folder name ?"
else
    scriptList=$(getScriptsName $1)
    if ! [[ -z $scriptList ]]; then
        setUTF "$scriptList"
    else
        echo "[!] Folder not found"
    fi
fi
