# Symbols
: ${is_a_git_repo_symbol:='❤'}
: ${has_untracked_files_symbol:='∿'}
: ${has_adds_symbol:='+'}
: ${has_deletions_symbol:='-'}
: ${has_deletions_cached_symbol:='✖'}
: ${has_modifications_symbol:='✎'}
: ${has_modifications_cached_symbol:='☲'}
: ${ready_to_commit_symbol:='→'}
: ${is_on_a_tag_symbol:='⌫'}
: ${needs_to_merge_symbol:='ᄉ'}
: ${has_upstream_symbol:='⇅'}
: ${detached_symbol:='⚯ '}
: ${can_fast_forward_symbol:='»'}
: ${has_diverged_symbol:='Ⴤ'}
: ${rebase_tracking_branch_symbol:='↶'}
: ${merge_tracking_branch_symbol:='ᄉ'}
: ${should_push_symbol:='↑'}
: ${has_stashes_symbol:='★'}

# Flags
: ${display_has_upstream:=false}
: ${display_tag:=false}
: ${display_tag_name:=true}
: ${two_lines:=true}
: ${finally:='\w ∙ '}
: ${use_color_off:=false}

# Colors
: ${on='\[\033[0;37m\]'}
: ${off='\[\033[1;30m\]'}
: ${red='\[\033[0;31m\]'}
: ${green='\[\033[0;32m\]'}
: ${yellow='\[\033[0;33m\]'}
: ${violet='\[\033[0;35m\]'}
: ${branch_color='\[\033[0;34m\]'}
#: ${blinking='\[\033[1;5;17m\]'}
: ${reset='\[\033[0m\]'}

function enrich {
	flag=$1
	symbol=$2
	if [[ -n $3 ]]; then
		coloron=$3
	else
		coloron=$on
	fi
	if [ $use_color_off == false -a $flag == false ]; then symbol=" "; fi
	if [[ $flag == true ]]; then color=$coloron; else color=$off; fi
	PS1="${PS1}${color}${symbol}${reset} "
}

function build_prompt {
	PS1=""

	# Git info
	current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
	current_commit_hash_abbrev=$(git rev-parse --short HEAD 2> /dev/null)
	if [[ -n $current_commit_hash ]]; then is_a_git_repo=true; else is_a_git_repo=false; fi

	number_of_logs=$(git log --pretty=oneline 2> /dev/null | wc -l)
	current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

	if [[ $current_branch == 'HEAD' ]]; then detached=true; else detached=false; fi

	if [[ $is_a_git_repo == true && $number_of_logs == 0 ]]; then just_init=true; fi
	if [[ $is_a_git_repo == true && $number_of_logs -gt 0 ]]; then 
		upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
		if [[ $upstream != '@{upstream}' ]]; then has_upstream=true; else has_upstream=false; upstream=''; fi

		git_status=$(git status --porcelain 2> /dev/null)

		if [[ $git_status =~ ^.M ]]; then has_modifications=true; else has_modifications=false; fi

		if [[ $git_status =~ ^M ]]; then has_modifications_cached=true; else has_modifications_cached=false; fi

		if [[ $git_status =~ ^A ]]; then has_adds=true; else has_adds=false; fi

		if [[ $git_status =~ ^.D ]]; then has_deletions=true; else has_deletions=false; fi

		if [[ $git_status =~ ^D ]]; then has_deletions_cached=true; else has_deletions_cached=false; fi

		if [[ $git_status =~ ^[MAD] && ! $git_status =~ ^.[MAD\?] ]]; then ready_to_commit=true; else ready_to_commit=false; fi

		if [[ $git_status =~ ^\?\? ]]; then has_untracked_files=true; else has_untracked_files=false; fi

		tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
		if [[ -n $tag_at_current_commit ]]; then is_on_a_tag=true; else is_on_a_tag=false; fi

		has_diverged=false
		can_fast_forward=false
		
		commits_diff=$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)

		OLD_IFS=$IFS # save ifs
		IFS=$'\n'

		commits_ahead=(${commits_diff//>*/})
		commits_behind=(${commits_diff//<*/})

		IFS=$OLD_IFS # restore ifs
		
		commits_ahead=${#commits_ahead[@]}
		commits_behind=${#commits_behind[@]}

		if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then
			has_diverged=true
		fi
		if [[ $commits_ahead == 0 && $commits_behind -gt 0 ]]; then
			can_fast_forward=true
		fi

		will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)

		number_of_stashes=$(git stash list | wc -l)
		if [[ $number_of_stashes -gt 0 ]]; then has_stashes=true; else has_stashes=false; fi
	else
		is_on_a_tag=false
	fi

	if [[ $is_a_git_repo == true ]]; then
		enrich $is_a_git_repo $is_a_git_repo_symbol $violet
		enrich $has_stashes $has_stashes_symbol $yellow
		enrich $has_untracked_files $has_untracked_files_symbol $red
		enrich $has_adds $has_adds_symbol $yellow

		enrich $has_deletions $has_deletions_symbol $red
		enrich $has_deletions_cached $has_deletions_cached_symbol $yellow

		enrich $has_modifications $has_modifications_symbol $red
		enrich $has_modifications_cached $has_modifications_cached_symbol $yellow
		enrich $ready_to_commit $ready_to_commit_symbol $green

		enrich $detached $detached_symbol $red

		if [[ $display_has_upstream == true ]]; then
			enrich $has_upstream $has_upstream_symbol
		fi
		if [[ $detached == true ]]; then
			if [[ $just_init == true ]]; then
				PS1="${PS1}${red}detached"
			else
				PS1="${PS1}${on}(${current_commit_hash_abbrev})"
			fi
		else
			if [[ $has_upstream == true ]]; then
				if [[ $will_rebase == true ]]; then
					type_of_upstream=$rebase_tracking_branch_symbol
				else
					type_of_upstream=$merge_tracking_branch_symbol
				fi

				if [[ $has_diverged == true ]]; then
					PS1="${PS1}-${commits_behind} ${has_diverged_symbol} +${commits_ahead} "
				else
					if [[ $commits_behind -gt 0 ]]; then
						PS1="${PS1}${on} -${commits_behind} ${can_fast_forward_symbol} "
					fi
					if [[ $commits_ahead -gt 0 ]]; then
						PS1="${PS1}${on} ${should_push_symbol} +${commits_ahead} "
					fi
				fi
				PS1="${PS1}(${green}${current_branch}${reset} ${type_of_upstream} ${upstream//\/$current_branch/})"
			else
				PS1="${PS1}${on}(${green}${current_branch}${reset})"
			fi
		fi

		if [[ $display_tag == true ]]; then
			PS1="${PS1}${yellow}${is_on_a_tag_symbol}${reset}"
		fi
		if [[ $display_tag_name == true && $is_on_a_tag == true ]]; then
			PS1="${PS1}${yellow}[${tag_at_current_commit}]${reset}"
		fi
	fi

	if [[ $two_lines == true && $is_a_git_repo == true ]]; then
		break='\n'
	else
		break=''
	fi

	PS1="${PS1}${reset}${break}${finally}"
}

PS2="${yellow}→${reset} "

PROMPT_COMMAND=build_prompt
