function enrich {
    flag=$1
    symbol=$2
    if [[ -n $3 ]]
    then
	coloron=$3
    else
	coloron=${on}
    fi
    if [[ $flag == true ]]; then color="${coloron}"; else color="${off}"; fi
    PS1="${PS1}${color}${symbol} "
}
function enrich_if_not_null {
    symbol=$1
    variable=$2
    flag=false
    if [[ -n "$variable" ]]
    then
        flag="true"
    else
	flag="false"
    fi
    enrich "${flag}" "${symbol}"
}

function enrich_if_equal {
    symbol=$1
    variable=$2
    condition=$3
    if [[ $variable == "${condition}" ]]
    then
        flag="true"
    else
	flag="false"
    fi
    enrich "${flag}" "${symbol}"
}

function enrich_if_greater_than_zero {
    symbol=$1
    variable=$2
    if [[ $variable -gt 0 ]]
    then
        flag="true"
    else
	flag="false"
    fi
    enrich "${flag}" "${symbol}"
}

function build_prompt {
    PS1=""
    # Colors
    on="\[\033[0;37m\]"    
    off="\[\033[1;30m\]"
    alert="\[\033[0;31m\]"
    branch_color="\[\033[0;34m\]"
    blinking="\[\033[1;5;17m\]"
    reset="\[\033[0m\]"

    # Git info
    echo 1
    current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
    current_commit_hash_abbrev=$(git rev-parse --short HEAD 2> /dev/null)
    if [[ -n $current_commit_hash ]]; then is_a_git_repo=true; else is_a_git_repo=false; fi
    
    if [[ $is_a_git_repo == true ]]; then 
	current_branch=$(git rev-parse --abbrev-ref HEAD); 
	if [[ $current_branch == "HEAD" ]]; then detached=true; else detached=false; fi
	upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
	if [[ $upstream != "@{upstream}" ]]; then has_upstream=true; else has_upstream=false; upstream=""; fi
    fi
    echo "is a git repo: ${is_a_git_repo}"
    echo "current commit hash: ${current_commit_hash}"
    echo "current branch: ${current_branch}"
    echo "is detached: ${detached}"
    echo "upstream branch: ${upstream}"
    echo "Has upstream: ${has_upstream}"
    echo "-------------"


    enrich ${is_a_git_repo} "❤"
    enrich ${detached} "⚯" "${alert}"

    number_of_modifications=$(git status --short 2> /dev/null|grep --count -e ^\.M)
    if [[ ${number_of_modifications} -gt 0 ]] ; then  has_modifications=true;    else	has_modifications=false;  fi
    enrich $has_modifications "✎"

    number_of_modifications_cached=$(git status --short 2> /dev/null|grep --count -e ^M)
    enrich_if_greater_than_zero "→" "${number_of_modifications_cached}"

    number_of_untracked=$(git status --short 2> /dev/null|grep --count -e ^\?\?)
    enrich_if_greater_than_zero "∿" "${number_of_untracked}"

    if [[ ${is_a_git_repo} == true ]]
    then
	if [[ ${detached} == true ]]
	then
	    PS1="${PS1} ${on}($current_commit_hash_abbrev)"
	else
	    PS1="${PS1} ${on}(${current_branch})"
	fi

    fi
    PS1="${PS1}${reset} :"

}


#PREVIOUS_PROMPT=$PS1
PROMPT_COMMAND=build_prompt
