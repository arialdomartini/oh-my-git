function enrich {
    flag=$1
    symbol=$2
    if [[ -n $3 ]]; then
        coloron=$3
    else
        coloron=$on
    fi
    if [[ $use_color_off == false && $flag == false ]]; then symbol=' '; fi
    if [[ $flag == true ]]; then color=$coloron; else color=$off; fi
    PS1="${PS1}${color}${symbol}${reset} "
}

function build_prompt {
    enabled=`git config --local --get oh-my-git.enabled`
    if [[ ${enabled} == false ]]; then
        echo "${PSORG}"
        exit;
    fi

    PS1=""    
    # Git info
    current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
    if [[ -n $current_commit_hash ]]; then is_a_git_repo=true; else is_a_git_repo=false; fi
    
    if [[ $is_a_git_repo == true ]]; then
        current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
        if [[ $current_branch == 'HEAD' ]]; then detached=true; else detached=false; fi
    
        number_of_logs=$(git log --pretty=oneline -n1 2> /dev/null | wc -l)
        if [[ $number_of_logs -eq 0 ]]; then
            just_init=true
        else
            upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
            if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then has_upstream=true; else has_upstream=false; fi

            git_status=$(git status --porcelain 2> /dev/null)
        
            if [[ $git_status =~ ($'\n'|^).M ]]; then has_modifications=true; else has_modifications=false; fi
        
            if [[ $git_status =~ ($'\n'|^)M ]]; then has_modifications_cached=true; else has_modifications_cached=false; fi
        
            if [[ $git_status =~ ($'\n'|^)A ]]; then has_adds=true; else has_adds=false; fi
        
            if [[ $git_status =~ ($'\n'|^).D ]]; then has_deletions=true; else has_deletions=false; fi
        
            if [[ $git_status =~ ($'\n'|^)D ]]; then has_deletions_cached=true; else has_deletions_cached=false; fi
        
            if [[ $git_status =~ ($'\n'|^)[MAD] && ! $git_status =~ ($'\n'|^).[MAD\?] ]]; then ready_to_commit=true; else ready_to_commit=false; fi
        
            number_of_untracked_files=`echo "${git_status}" | $(sh -c 'which grep') -c "^??"`
            if [[ $number_of_untracked_files -gt 0 ]]; then has_untracked_files=true; else has_untracked_files=false; fi
        
            tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
            if [[ -n $tag_at_current_commit ]]; then is_on_a_tag=true; else is_on_a_tag=false; fi
        
            has_diverged=false
            can_fast_forward=false
        
            if [[ $has_upstream == true ]]; then
                commits_diff=$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)
                commits_ahead=$(`sh -c 'which grep'` -c "^<" <<< "$commits_diff")
                commits_behind=$(`sh -c 'which grep'` -c "^>" <<< "$commits_diff")
            fi
            if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then
                has_diverged=true
            fi
            if [[ $commits_ahead -eq 0 && $commits_behind -gt 0 ]]; then
                can_fast_forward=true
            fi
        
            will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)
        
            if [[ -f ${GIT_DIR:-.git}/refs/stash ]]; then
                number_of_stashes=$(wc -l 2> /dev/null < ${GIT_DIR:-.git}/refs/stash)
            else
                number_of_stashes=0
            fi
            if [[ $number_of_stashes -gt 0 ]]; then has_stashes=true; else has_stashes=false; fi
    fi
    fi
    
    if [[ $is_a_git_repo == true ]]; then
        enrich $is_a_git_repo $omg_is_a_git_repo_symbol $violet
        enrich $has_stashes $has_stashes_symbol $yellow
        enrich $has_untracked_files $omg_has_untracked_files_symbol $red
        enrich $has_adds $omg_has_adds_symbol $yellow
    
        enrich $has_deletions $omg_has_deletions_symbol $red
        enrich $has_deletions_cached $omg_has_cached_deletions_symbol $yellow
    
        enrich $has_modifications $omg_has_modifications_symbol $red
        enrich $has_modifications_cached $omg_has_cached_modifications_symbol $yellow
        enrich $ready_to_commit $omg_ready_to_commit_symbol $green
        
        enrich $detached $detached_symbol $red
    
        if [[ $display_has_upstream == true ]]; then
            enrich $has_upstream $has_upstream_symbol
        fi
        if [[ $detached == true ]]; then
            if [[ $just_init == true ]]; then
                PS1="${PS1} ${red}detached"
            else
                PS1="${PS1} ${on}(${current_commit_hash:0:7})"
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
        
        if [[ $display_tag == true && $is_on_a_tag == true ]]; then
            PS1="${PS1} ${yellow}${omg_is_on_a_tag_symbol}${reset}"
        fi
        if [[ $display_tag_name == true && $is_on_a_tag == true ]]; then
            PS1="${PS1} ${yellow}[${tag_at_current_commit}]${reset}"
        fi
        PS1="${PS1}      "
    fi
    
    if [[ $two_lines == true && $is_a_git_repo == true ]]; then
        break='\n'
    else
        break=''
    fi
    
    echo "${PS1}${reset}${break}${finally}${reset}"
}
