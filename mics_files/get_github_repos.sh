#!/bin/bash
#===================================================================================================================
# Description: Get all the repositories from the GitHub account
# Author: Solorzano, Juan Jose.
# Date: 22/03/2025
# Version: 1.0
# License: MIT License
# Script to get all the repositories from the GitHub account.
# The script can count the total number of repositories, clone all the repositories, or just list the repositories.
# The script requires a GitHub API token to access the repositories.
# The script will create a directory called repos to store the repositories.
# The script will create a file called repos.txt to store the URLs of the repositories.
# ------------------------------------------------------------------------------------------------------------------
# Usage: 
# ./get_server.sh [-c] [-C] <GitHub api token>
# -c: Count the total number of repositories
# -C: Clone all the repositories.
#===================================================================================================================

gitHub_server="https://github.com"
count_repos=false
clone_repos=false
# Get the options from the command line.
while getopts ":cCh" opt; do
  case $opt in
    h)
      echo "Usage: $0 [-c] [-C] <GitHub api token>"
      echo "Options:"
      echo "-c: Count the total number of repositories"
      echo "-C: Clone all the repositories."
      exit 0
      ;;
    c)
      if [ "$clone_repos" = true ]; then
        count_repos=false
      else
        count_repos=true
      fi
      ;;
    C)
      clone_repos=true
      count_repos=false
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1)) # Remove the options from the command line.

if [ -z "$1" ]; then # Check if the GitHub API token is provided.
    echo "Usage: $0 [-c] [-C] <GitHub api token>"
    exit 1
else # All went well, get the GitHub API token.
    token=$1
    clear # Clear the screen.
    printf "+++++++++++++++++++++++++++{ Repository cloner }+++++++++++++++++++++++++++++++\n"
    echo "Version: 1.0"
    echo "Author: Solorzano, Juan Jose."
    echo "Date: 22/03/2025"
    echo "License: MIT License"
    printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
fi

# Get the repositories names from the GitHub account using a curl request.
repo_names=$(curl -s -H "Authorization: token $token" "https://api.github.com/user/repos?per_page=100&page=1" | grep -i "full_name" | awk '{print $2}' NF=':' | tr -d ',' | tr -d '"')

# If sentence to check the options.
if $count_repos; then # If count_repos is true, count the total number of repositories.
    total_repos=$(echo "$repo_names" | wc -l)
    echo "Total repositories: $total_repos"
elif $clone_repos; then # if clone_repos is true, clone all the repositories.
    total_repos=$(echo "$repo_names" | wc -l)
    #if [ -d "repos" ]; then
    #    rm -rf repos
    #fi
    mkdir repos 2>/dev/null # Create a directory to store the repositories.
    cd repos || exit # If the directory does not exist, exit the script
    for repo_name in $repo_names; do
        cnt=$((cnt+1))
        name=$(echo "$repo_name" | cut -d'/' -f2)
        printf "[+] Cloning repository: %s (%s of %s)\n" "$name" "$cnt" "$total_repos"
        echo clone $gitHub_server/"$repo_name".git
        sleep 3
        printf '%.0s-' {1..80}; echo
    done
    echo "[+] Done cloning repositories"
else # Just list the repositories.
    for repo_name in $repo_names; do
        echo $gitHub_server/"$repo_name"
        echo $gitHub_server/"$repo_name".git >> repos.txt
    done
    echo "[+] Done"
fi