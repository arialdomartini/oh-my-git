# Based on the work of fabulous work of Arialdo Martini
# https://github.com/arialdomartini/oh-my-git/

function oh_my_git_info {
	local oh_my_git_string="";

	# Colors
	local on="${omg_on:-\[\e[0;37m\]}";
	local off="${omg_off:-\[\e[1;30m\]}";
	local red="${omg_red:-\[\e[0;31m\]}";
	local green="${omg_green:-\[\e[0;32m\]}";
	local yellow="${omg_yellow:-\[\e[0;33m\]}";
	local violet="${omg_violet:-\[\e[0;35m\]}";
	local reset="${omg_reset:-\[\e[0m\]}";
	
	# Symbols
	if [[ -z "${is_a_git_repo_symbol}" ]]; then local is_a_git_repo_symbol="±"; fi
	if [[ -z "${is_a_git_repo_color}" ]]; then local is_a_git_repo_color="$violet"; fi
	if [[ -z "${has_untracked_files_symbol}" ]]; then local has_untracked_files_symbol="∿"; fi
	if [[ -z "${has_untracked_files_color}" ]]; then local has_untracked_files_color="$red"; fi
	if [[ -z "${has_adds_symbol}" ]]; then local has_adds_symbol="+"; fi
	if [[ -z "${has_adds_color}" ]]; then local has_adds_color="$yellow"; fi
	if [[ -z "${has_deletions_symbol}" ]]; then local has_deletions_symbol="-"; fi
	if [[ -z "${has_deletions_color}" ]]; then local has_deletions_color="$red"; fi
	if [[ -z "${has_deletions_cached_symbol}" ]]; then local has_deletions_cached_symbol="✖"; fi
	if [[ -z "${has_deletions_cached_color}" ]]; then local has_deletions_cached_color="$yellow"; fi
	if [[ -z "${has_modifications_symbol}" ]]; then local has_modifications_symbol="✎"; fi
	if [[ -z "${has_modifications_color}" ]]; then local has_modifications_color="$red"; fi
	if [[ -z "${has_modifications_cached_symbol}" ]]; then local has_modifications_cached_symbol="☲"; fi
	if [[ -z "${has_modifications_cached_color}" ]]; then local has_modifications_cached_color="$yellow"; fi
	if [[ -z "${ready_to_commit_symbol}" ]]; then local ready_to_commit_symbol="→"; fi
	if [[ -z "${ready_to_commit_color}" ]]; then local ready_to_commit_color="$green"; fi
	if [[ -z "${is_on_a_tag_symbol}" ]]; then local is_on_a_tag_symbol="⌫"; fi
	if [[ -z "${is_on_a_tag_color}" ]]; then local is_on_a_tag_color="$yellow"; fi
	if [[ -z "${needs_to_merge_symbol}" ]]; then local needs_to_merge_symbol="ᄉ"; fi
	if [[ -z "${needs_to_merge_color}" ]]; then local needs_to_merge_color="$yellow"; fi
	if [[ -z "${has_upstream_symbol}" ]]; then local has_upstream_symbol="⇅"; fi
	if [[ -z "${has_upstream_color}" ]]; then local has_upstream_color="$on"; fi
	if [[ -z "${has_no_upstream_color}" ]]; then local has_no_upstream_color="$on"; fi
	if [[ -z "${detached_symbol}" ]]; then local detached_symbol="⚯"; fi
	if [[ -z "${detached_color}" ]]; then local detached_color="$red"; fi
	if [[ -z "${detached_current_commit_color}" ]]; then local detached_current_commit_color="$on"; fi
	if [[ -z "${can_fast_forward_symbol}" ]]; then local can_fast_forward_symbol="»"; fi
	if [[ -z "${can_fast_forward_color}" ]]; then local can_fast_forward_color="$on"; fi
	if [[ -z "${has_diverged_symbol}" ]]; then local has_diverged_symbol="Ⴤ"; fi
	if [[ -z "${has_diverged_color}" ]]; then local has_diverged_color="$red"; fi
	if [[ -z "${rebase_tracking_branch_symbol}" ]]; then local rebase_tracking_branch_symbol="↶"; fi
	if [[ -z "${rebase_tracking_branch_color}" ]]; then local rebase_tracking_branch_color="$reset"; fi
	if [[ -z "${merge_tracking_branch_symbol}" ]]; then local merge_tracking_branch_symbol="ᄉ"; fi
	if [[ -z "${merge_tracking_branch_color}" ]]; then local merge_tracking_branch_color="$reset"; fi
	if [[ -z "${should_push_symbol}" ]]; then local should_push_symbol="↑"; fi
	if [[ -z "${should_push_color}" ]]; then local should_push_color="$on"; fi
	if [[ -z "${has_stashes_symbol}" ]]; then local has_stashes_symbol="★"; fi
	if [[ -z "${has_stashes_color}" ]]; then local has_stashes_color="$yellow"; fi
	if [[ -z "${commits_behind_symbol}" ]]; then local commits_behind_symbol="-"; fi
	if [[ -z "${commits_behind_color}" ]]; then local commits_behind_color="$reset"; fi
	if [[ -z "${commits_ahead_symbol}" ]]; then local commits_ahead_symbol="+"; fi
	if [[ -z "${commits_ahead_color}" ]]; then local commits_ahead_color="$reset"; fi
	if [[ -z "${current_branch_color}" ]]; then local current_branch_color="$green"; fi
	if [[ -z "${tag_name_color}" ]]; then local tag_name_color="$yellow"; fi


	# flags
	if [[ -z "${display_has_upstream}" ]]; then local display_has_upstream=false; fi
	if [[ -z "${display_tag}" ]]; then local display_tag=false; fi
	if [[ -z "${display_tag_name}" ]]; then local display_tag_name=true; fi
	if [[ -z "${use_color_off}" ]]; then local use_color_off=false; fi
	if [[ -z "${print_unactive_flags_space}" ]]; then local print_unactive_flags_space=true; fi
	if [[ -z "${display_git_symbol}" ]]; then local display_git_symbol=true; fi
	if [[ -z "${display_git_current_action}" ]]; then local display_git_current_action=false; fi

	# Early return if git repo is configured to be hidden
	if [[ "$(git config --get oh-my-zsh.hide-status)" == "1" ]]; then return; fi

	# Git info
	local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
	if [[ -n $current_commit_hash ]]; then local is_a_git_repo=true; else local is_a_git_repo=false; fi
	
	if [[ $is_a_git_repo == true ]]; then
		local current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
		if [[ $current_branch == 'HEAD' ]]; then local detached=true; else local detached=false; fi
	
		local number_of_logs=$(git log --pretty=oneline -n1 2> /dev/null | wc -l | tr -d ' ')
		if [[ $number_of_logs -eq 0 ]]; then
			local just_init=true
		else
			local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
			if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then local has_upstream=true; else local has_upstream=false; fi

			local git_status="$(git status --porcelain 2> /dev/null)"
		
			if [[ $git_status =~ ($'\n'|^).M ]]; then local has_modifications=true; else local has_modifications=false; fi
		
			if [[ $git_status =~ ($'\n'|^)M ]]; then local has_modifications_cached=true; else local has_modifications_cached=false; fi
		
			if [[ $git_status =~ ($'\n'|^)A ]]; then local has_adds=true; else local has_adds=false; fi
		
			if [[ $git_status =~ ($'\n'|^).D ]]; then local has_deletions=true; else local has_deletions=false; fi
		
			if [[ $git_status =~ ($'\n'|^)D ]]; then local has_deletions_cached=true; else local has_deletions_cached=false; fi
		
			if [[ $git_status =~ ($'\n'|^)[MAD] && ! $git_status =~ ($'\n'|^).[MAD\?] ]]; then local ready_to_commit=true; else local ready_to_commit=false; fi
		
			local number_of_untracked_files=`echo $git_status | grep -c "^??"`
			if [[ $number_of_untracked_files -gt 0 ]]; then local has_untracked_files=true; else local has_untracked_files=false; fi
		
			local tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
			if [[ -n $tag_at_current_commit ]]; then local is_on_a_tag=true; else local is_on_a_tag=false; fi
		
			local has_diverged=false
			local can_fast_forward=false
		
			if [[ $has_upstream == true ]]; then
				local commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
				local commits_ahead=$(grep -c "^<" <<< "$commits_diff");
				local commits_behind=$(grep -c "^>" <<< "$commits_diff");
			fi
			if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then
				local has_diverged=true
			fi
			if [[ $commits_ahead -eq 0 && $commits_behind -gt 0 ]]; then
				local can_fast_forward=true
			fi
		
			local will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)
		
			if [[ -f ${GIT_DIR:-.git}/refs/stash ]]; then
				local number_of_stashes=$(wc -l 2> /dev/null < ${GIT_DIR:-.git}/refs/stash | tr -d ' ')
			else
				local number_of_stashes=0
			fi
			if [[ $number_of_stashes -gt 0 ]]; then local has_stashes=true; else local has_stashes=false; fi
		fi
	fi


	if [[ ${is_a_git_repo} == true ]]; then
		oh_my_git_string="
			$(echo_if_true ${display_git_symbol} ${is_a_git_repo_symbol} ${is_a_git_repo_color})
			
			$(echo_if_true ${has_stashes} ${has_stashes_symbol} ${has_stashes_color})
			$(echo_if_true ${has_untracked_files} ${has_untracked_files_symbol} ${has_untracked_files_color})
			$(echo_if_true ${has_adds} ${has_adds_symbol} ${has_adds_color})

			$(echo_if_true ${has_deletions} ${has_deletions_symbol} ${has_deletions_color})
			$(echo_if_true ${has_deletions_cached} ${has_deletions_cached_symbol} ${has_deletions_cached_color})

			$(echo_if_true ${has_modifications} ${has_modifications_symbol} ${has_modifications_color})
			$(echo_if_true ${has_modifications_cached} ${has_modifications_cached_symbol} ${has_modifications_cached_color})
			$(echo_if_true ${ready_to_commit} ${ready_to_commit_symbol} ${ready_to_commit_color})

			$(echo_if_true ${detached} ${detached_symbol} ${detached_color})
		";

		if [[ ${display_has_upstream} == true ]]; then
			oh_my_git_string+="$(echo_if_true ${has_upstream} ${has_upstream_symbol} ${has_upstream_color})";
		fi
		
		if [[ ${detached} == true ]]; then
			if [[ ${just_init} == true ]]; then
				oh_my_git_string+="${detached_color}detached${reset}";
			else
				oh_my_git_string+="${detached_current_commit_color}(${current_commit_hash:0:7})${reset}";
			fi
		else
			if [[ $has_upstream == true ]]; then
				if [[ ${will_rebase} == true ]]; then 
					type_of_upstream="${rebase_tracking_branch_color}${rebase_tracking_branch_symbol}${reset}"; 
				else
					type_of_upstream="${merge_tracking_branch_color}${merge_tracking_branch_symbol}${reset}"; 
				fi
		
				if [[ ${has_diverged} == true ]]; then
					oh_my_git_string+="
						${commits_behind_color}${commits_behind_symbol}${commits_behind}${reset}
						${has_diverged_color}${has_diverged_symbol}${reset}
						${commits_ahead_color}${commits_ahead_symbol}${commits_ahead}${reset}
					";
				else
					if [[ ${commits_behind} -gt 0  ]]; then
						oh_my_git_string+="
							${can_fast_forward_color}${commits_behind_symbol}${commits_behind} ${can_fast_forward_symbol}${reset}
						";
					fi
					if [[ ${commits_ahead} -gt 0 ]]; then
						oh_my_git_string+="
							${should_push_color}${should_push_symbol} ${commits_ahead_symbol}${commits_ahead} ${reset}
						";
					fi
				fi
		
				oh_my_git_string+="
					(${current_branch_color}${current_branch}${reset}
						${type_of_upstream}
						${upstream//\/$current_branch/})";
		
			else
				oh_my_git_string+="
					${has_no_upstream_color}(${current_branch_color}${current_branch}${reset}${has_no_upstream_color})${reset}
				";
			fi
		fi
		
		if [[ ${display_tag} == true ]]; then
			oh_my_git_string+=" ${is_on_a_tag_color}${is_on_a_tag_symbol}${reset}";
		fi
		if [[ ${display_tag_name} == true && ${is_on_a_tag} == true ]]; then
			oh_my_git_string+=" ${tag_name_color}[${tag_at_current_commit}]${reset}";
		fi
		
		if [[ $display_git_current_action == "left" ]]; then
			oh_my_git_string="$(git_current_action $red $reset) ${oh_my_git_string}";
		elif [[ $display_git_current_action == "right" ]]; then
			oh_my_git_string="${oh_my_git_string} $(git_current_action $red $reset)";
		fi
		
		# clean up leading and trailing spaces, (prefix and suffix might add them if wanted)
		oh_my_git_string=$(trim "$oh_my_git_string");
		
		oh_my_git_string="${omg_prefix}${oh_my_git_string}${reset}${omg_suffix}";
	fi

	# collapse contiguous spaces including new lines
	echo $(echo "${oh_my_git_string}")
}


# based on bash __git_ps1 to read branch and current action
function git_current_action () {
	local info="$(git rev-parse --git-dir 2>/dev/null)"
	if [ -n "$info" ]; then
		local action
		if [ -f "$info/rebase-merge/interactive" ]
			then
			action=${is_rebasing_interactively:-"REBASE-i"}
		elif [ -d "$info/rebase-merge" ]
			then
			action=${is_rebasing_merge:-"REBASE-m"}
		else
			if [ -d "$info/rebase-apply" ]
				then
				if [ -f "$info/rebase-apply/rebasing" ]
					then
					action=${is_rebasing:-"REBASE"}
				elif [ -f "$info/rebase-apply/applying" ]
					then
					action=${is_applying_mailbox_patches:-"|AM"}
				else
					action=${is_rebasing_mailbox_patches:-"AM/REBASE"}
				fi
			elif [ -f "$info/MERGE_HEAD" ]
				then
				action=${is_merging:-"MERGING"}
			elif [ -f "$info/CHERRY_PICK_HEAD" ]
				then
				action=${is_cherry_picking:-"CHERRY-PICKING"}
			elif [ -f "$info/BISECT_LOG" ]
				then
				action=${is_bisecting:-"BISECTING"}
			fi  
		fi
		
		if [[ -n $action ]]; then printf "%s" "${1-}$action${2-}"; fi
	fi
}


function echo_if_true {
	flag=$1
	symbol=$2
	if [[ -n $3 ]]; then
		coloron=$3
	else
		coloron=${on}
	fi
	if [[ ${use_color_off} == false && ${flag} == false ]]; then symbol=' '; fi
	if [[ $flag == true ]]; then color="${coloron}"; else color="${off}"; fi
	if [[ ${print_unactive_flags_space} == false && ${flag} == false ]]; then
		return;
	else
		echo "${color}${symbol}${reset}";
	fi
}


if [ -n "$ZSH_VERSION" ]; then
   function trim() {
		leading_trimmed="${1##+([[:space:]])}";
		trimmed="${leading_trimmed%%+([[:space:]])}";
		echo "$trimmed";
   }
elif [ -n "$BASH_VERSION" ]; then
   function trim() {
	   leading_trimmed="${1#"${1%%[![:space:]]*}"}";
	   trimmed="${leading_trimmed%"${leading_trimmed##*[![:space:]]}"}";
	   echo "$trimmed";
   }
else
   function trim() {
	   return $1;
   }
fi
