#!/bin/bash
# Author: Solorzano, Juan Jose

RED='\033[0;31m'
BLUE='\034[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
END_COLOR='\033[0m'
# change to ~ directory.
source ~/.myconf #environment configuration.

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

# Aliases
alias ll="ls -la"
alias delete="rm -fr"

# Shows the current git branch and status
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

function git-update {
    git diff origin/$1 --name-status | grep -v -E "$2"
}

function temp {
    cd ~/temp/
}

# Change to project directory.
function prj {
    project_name=$1
    list_=$2
    if [[ -z "$project_name" ]]; then
        printf "Project name is required\n"
        return 1
    fi
    ret_path=$(find /d/p_ta3 -type d -iname "$1" -print -quit)
    if [[ -z "$ret_path" ]]; then
        printf "Project not found\n %s" "$ret_path"
    else
        cd $ret_path
    fi
}

function repo {
    repo_name=$1
    if [[ -z "$repo_name" ]]; then
        printf "Repository name is required\n"
        printf "repo <name>\n"
        return 1
    fi
    declare -A repos
    repos["G90"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.GM.G90.CVR"
    repos["G80"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.GM.G80.CVR"
    repos["G70"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.GM.G70.CVR"
    repos["FC1"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.FORD.FC1.REGR_TEST"
    repos["FB0"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.FORD.FB0.REGR_TEST"
    repos["FB1"]="https://gitlab-ec-na.aws1583.vitesco.io/ec/se/aet/tas/ford/fofb0_ta_suite"
    repos["G55"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.GM.G55.FAST"
    repos["G56"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.GM.G56.VVMAL"
    repos["CONTEST"]="https://github.vitesco.io/EnDS-Test-Automation/VT.GEN.TOOL.CONTEST"
    repos["FC1_"]="https://github.vitesco.io/uiv06924/fo_fc1_ta_suite"
    repos["H02"]="https://github.vitesco.io/EnDS-Test-Automation/vt.prj.ford.foh02.sys_test"
    repos["myrecorder"]="https://github.vitesco.io/uiv06924/MyRecorder"
    repos["AUTOCNF"]="https://github.vitesco.io/EnDS-Test-Automation/VT.PRJ.AUTO_CNF_TOOL"
    echo "${repos["G80"]}"
}

function up {
    for i in `seq 1 $1`;
    do
        cd ../
    done;
}

function rc {
    printf '\e[6 q'
}

function getFolderName {
    folderName=$(echo $(pwd) | awk -F'/' '{print $NF}')
    printf "$folderName"
}

function my_prompt {
    isRepo=$(git rev-parse --is-inside-work-tree 2>/dev/null)
    if [[ -z $isRepo ]]; then
        export PS1="${CYAN}📂\w${ENDCOLOR}${MAGENTA}\$(git_ps1)${ENDCOLOR}/🐧> "
    else
        export PS1="${CYAN}📂\$(getFolderName)${ENDCOLOR}${MAGENTA}\$(git_ps1)${ENDCOLOR}/🐧> "
    fi
}

PROMPT_COMMAND=my_prompt
