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
    current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
    current_commit_hash_abbrev=$(git rev-parse --short HEAD 2> /dev/null)
    if [[ -n $current_commit_hash ]]; then is_a_git_repo=true; else is_a_git_repo=false; fi

    number_of_logs=$(git log 2>/dev/null| wc -l)
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); 

    if [[ $current_branch == "HEAD" ]]; then detached=true; else detached=false; fi

    if [ $is_a_git_repo == true -a $number_of_logs == 0 ]; then just_init=true; fi

    if [ $is_a_git_repo == true -a $number_of_logs -gt 0 ]; then 

	upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
	if [[ $upstream != "@{upstream}" ]]; then has_upstream=true; else has_upstream=false; upstream=""; fi
    
	number_of_modifications=$(git status --short 2> /dev/null|grep --count -e ^\.M)
	if [[ ${number_of_modifications} -gt 0 ]] ; then  has_modifications=true; else has_modifications=false;  fi
	
	number_of_adds=$(git status --short 2> /dev/null|grep --count -e ^\A)
	if [[ ${number_of_adds} -gt 0 ]] ; then  has_adds=true; else has_adds=false;  fi


	number_of_deletions=$(git status --short 2> /dev/null|grep --count -e ^.D)
	if [[ ${number_of_deletions} -gt 0 ]] ; then  has_deletions=true; else has_deletions=false;  fi
	number_of_deletions_cached=$(git status --short 2> /dev/null|grep --count -e ^D)
	if [[ ${number_of_deletions_cached} -gt 0 ]] ; then  has_deletions_cached=true; else has_deletions_cached=false;  fi

	number_of_modifications_cached=$(git status --short 2> /dev/null|grep --count -e ^[MA])
	if [[ ${number_of_modifications_cached} -gt 0 ]] ; then has_modifications_cached=true; else has_modifications_cached=false;  fi


	number_of_untracked_files=$(git status --short 2> /dev/null|grep --count -e ^\?\?)
	if [[ ${number_of_untracked_files} -gt 0 ]] ; then has_untracked_files=true; else has_untracked_files=false;  fi
    fi

#    echo "is a git repo:                ${is_a_git_repo}"
#    echo "current commit hash:          ${current_commit_hash}"
#    echo "current branch:               ${current_branch}"
#    echo "is detached:                  ${detached}"
#    echo "upstream branch:              ${upstream}"
#    echo "Has upstream:                 ${has_upstream}"
#    echo "Has mofications:              ${has_modifications}"
#    echo "Has mofications_cached:       ${has_modifications_cached}"
#    echo "Has untracked files:          ${has_untracked_files}"
#    echo "Has deletions:                ${has_deletions}"
#    echo "Has adds:                     ${has_adds}"
#echo "Just init:                        ${just_init}"

    if [[ ${is_a_git_repo} == true ]]
    then
	enrich ${is_a_git_repo} "❤"
	enrich ${has_untracked_files} "∿"
	enrich ${has_adds} "+"

	enrich ${has_deletions} "-"
	enrich ${has_deletions_cached} "✖"


	enrich ${has_modifications} "✎"
	enrich ${has_modifications_cached} "→"

	need_to_merge=true
	can_fast_forward=true
	will_merge=true
	will_rebase=true

	enrich ${on_a_tag} "⌫"
	enrich ${detached} "⚯" "${alert}"


	enrich ${need_to_merge} "ᄉ" "${alert}"
	enrich ${can_fast_forward} "»"

	enrich ${has_upstream} "↕"
	if [[ ${detached} == true ]]
	then
	    if [[ ${just_init} == true ]]; then
		PS1="${PS1} ${alert}detached"
	    else
		PS1="${PS1} ${on}($current_commit_hash_abbrev)"
	    fi
	else
	    if [[ $has_upstream == true ]]
	    then

#		if [[ ${will_rebase} ]]; then type_of_upstream="↶"; fi
		if [[ ${will_merge} ]]; then type_of_upstream="ᄉ"; fi

		PS1="${PS1} ${on}(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})"
	    else
		PS1="${PS1} ${on}(${current_branch})"
	    fi
	fi

    fi
    PS1="${PS1}${reset}∙ "

}


#PREVIOUS_PROMPT=$PS1
PROMPT_COMMAND=build_prompt
