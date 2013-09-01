function build_prompt {
    PS1=""
    on="\[\033[0;33m\]"
    off="\[\033[1;31m\]"
    blinking="\[\033[1;5;17m\]"
    reset="\[\033[0m\]"

    current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)


    git_repo_s="❤"
    if [[ -z "$current_branch" ]]
    then
        git_repo=${off}
    else
        git_repo=${on}
    fi
    PS1="${PS1}${git_repo}${git_repo_s}"

	PS1="${PS1}${reset}:"
}


#PREVIOUS_PROMPT=$PS1
PROMPT_COMMAND=build_prompt
