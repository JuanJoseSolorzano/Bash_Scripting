#!bin/bash
# Author: Solorzano, Juan Jose

ENDCOLOR='\[\e[0m\]'
BLACK='\[\e[0;30m\]'
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
MAGENTA='\[\e[0;35m\]'
CYAN='\[\e[0;36m\]'
WHITE='\[\e[0;37m\]'
BBLACK='\[\e[1;30m\]'
BRED='\[\e[1;31m\]'
BGREEN='\[\e[1;32m\]'
BYELLOW='\[\e[1;33m\]'
BBLUE='\[\e[1;34m\]'
BMAGENTA='\[\e[1;35m\]'
BCYAN='\[\e[1;36m\]'
BWHITE='\[\e[1;37m\]'

if [ -f /etc/profile.d/git-prompt.sh ]; then
  . /etc/profile.d/git-prompt.sh
elif [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
  . /usr/share/git-core/contrib/completion/git-prompt.sh
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto

function git_ps1 {
    local gitStatus branchName branchStatus
    local showStatus unstaged untracked stash nothing
    gitStatus="$(__git_ps1 '%s')" || return 0
    branchName=$(echo "$gitStatus" | awk '{print $1}')
    branchStatus=$(echo "$gitStatus" | awk '{print $2}')

    [[ $branchStatus == *"*"* ]] && unstaged=1
    [[ $branchStatus == *"%"* ]] && untracked=1
    [[ $branchStatus == *"\$"* ]] && stash=1
    [[ $branchStatus == *"="* ]] && nothing=1
    [[ $branchStatus == *"+"* ]] && readyToCommit=1
    [[ $branchStatus == *">"* ]] && readyToPush=1
    [[ $branchName == *"master"* ]] && isMaster=1

    if [[ $unstaged -eq 1 || $untracked -eq 1 ]]; then
        if [[ $untracked -eq 1 ]];then
            showStatus=" "
        else
            showStatus=""
        fi
    elif [[ $stash -eq 1 ]]; then
        showStatus=" "
    elif [[ $nothing -eq 1 && $readyToCommit -eq 0 && $readyToPush -eq 0 ]]; then
        showStatus=""
    elif [[ $readyToCommit -eq 1 ]]; then
        showStatus=""
    elif [[ $readyToPush -eq 1 ]]; then
        showStatus=""
    else
        showStatus="${YELLOW} None${ENDCOLOR}"
    fi
    if [[ $isMaster -eq 1 ]]; then
        branchName="${branchName}!"
    fi
    if [ -d .git ];then
        printf "<%s%s>" "$showStatus" "$branchName"
    fi
}

function prj {
    find /d -type d -name "$1" -print -quit
}

function repo {
    echo ">> No implemented yet."
}

function up {
    for i in `seq 1 $1`;
    do
        cd ../
    done;
}

export PS1="${CYAN}📂\w${ENDCOLOR}${MAGENTA}\$(git_ps1)${ENDCOLOR}🐧> "
