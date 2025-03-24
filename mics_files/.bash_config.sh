#!/bin/bash
#====================================================================#
# Author: Solorzano, Juan Jose                                       #
# Purpose: this script contains the configuration for the bash shell.#
# Date:                                                              #
#--------------------------------------------------------------------#
# Usage:                                                             #
# $ source .bash_config.sh                                           #      
#====================================================================#
export repo1="[github_repository]"
export repo2="[github_repository]"
export repo3="[github_repository]"
export repo4="[github_repository]"

# Git
function mbr {
    branchName="$1"
    branchName=$(git rev-parse --abbrev-ref HEAD)
    echo "$branchName"
}
# Polarion
function polarion {
    mainUrl="[polarion_url]"
    if [ "$1" ]; then 
        request="$1" 
    else
        request=$mainUrl
    fi
    start $request
}