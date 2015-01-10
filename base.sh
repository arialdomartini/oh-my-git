function enrich {
    local flag=$1
    local symbol=$2
    if [[ -n $3 ]]; then
        local coloron=$3
    else
        local coloron=$omg_on
    fi
    if [[ $omg_use_color_off == false && $flag == false ]]; then symbol=' '; fi
    if [[ $flag == true ]]; then color=$coloron; else color=$omg_off; fi
    prompt="${prompt}${color}${symbol}${reset} "
}

function build_prompt {
    local enabled=`git config --local --get oh-my-git.enabled`
    if [[ ${enabled} == false ]]; then
        echo "${PSORG}"
        exit;
    fi

    local prompt=""
    # Git info
    local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
    if [[ -n $current_commit_hash ]]; then local is_a_git_repo=true; else local is_a_git_repo=false; fi
    
    if [[ $is_a_git_repo == true ]]; then
        local current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
        if [[ $current_branch == 'HEAD' ]]; then local detached=true; else local detached=false; fi

        local number_of_logs="$(git log --pretty=oneline -n1 2> /dev/null | wc -l)"
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
        
            local number_of_untracked_files=`echo "${git_status}" | $(sh -c 'which grep') -c "^??"`
            if [[ $number_of_untracked_files -gt 0 ]]; then local has_untracked_files=true; else has_untracked_files=false; fi
        
            local tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
            if [[ -n $tag_at_current_commit ]]; then local is_on_a_tag=true; else local is_on_a_tag=false; fi
        
            local has_diverged=false
            local can_fast_forward=false
        
            if [[ $has_upstream == true ]]; then
                local commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
                local commits_ahead=$(`sh -c 'which grep'` -c "^<" <<< "$commits_diff")
                local commits_behind=$(`sh -c 'which grep'` -c "^>" <<< "$commits_diff")
            fi
            if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then
                local has_diverged=true
            fi
            if [[ $commits_ahead -eq 0 && $commits_behind -gt 0 ]]; then
                local can_fast_forward=true
            fi
        
            local will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)
        
            if [[ -f ${GIT_DIR:-.git}/refs/stash ]]; then
                local number_of_stashes="$(wc -l 2> /dev/null < ${GIT_DIR:-.git}/refs/stash)"
            else
                local number_of_stashes=0
            fi
            if [[ $number_of_stashes -gt 0 ]]; then local has_stashes=true; else local has_stashes=false; fi
        fi
    fi
    
    if [[ $is_a_git_repo == true ]]; then
        enrich $is_a_git_repo $omg_is_a_git_repo_symbol $violet
        enrich $has_stashes $omg_has_stashes_symbol $yellow
        enrich $has_untracked_files $omg_has_untracked_files_symbol $red
        enrich $has_adds $omg_has_adds_symbol $yellow
    
        enrich $has_deletions $omg_has_deletions_symbol $red
        enrich $has_deletions_cached $omg_has_cached_deletions_symbol $yellow
    
        enrich $has_modifications $omg_has_modifications_symbol $red
        enrich $has_modifications_cached $omg_has_cached_modifications_symbol $yellow
        enrich $ready_to_commit $omg_ready_to_commit_symbol $green
        
        enrich $detached $omg_detached_symbol $red
    
        if [[ $omg_display_has_upstream == true ]]; then
            enrich $has_upstream $omg_has_upstream_symbol
        fi
        if [[ $detached == true ]]; then
            if [[ $just_init == true ]]; then
                prompt="${prompt} ${red}detached"
            else
                prompt="${prompt} ${omg_on}(${current_commit_hash:0:7})"
            fi
        else
            if [[ $has_upstream == true ]]; then
                if [[ $will_rebase == true ]]; then
                    local type_of_upstream=$omg_rebase_tracking_branch_symbol
                else
                    local type_of_upstream=$omg_merge_tracking_branch_symbol
                fi
                
                if [[ $has_diverged == true ]]; then
                    prompt="${prompt}-${commits_behind} ${omg_has_diverged_symbol} +${commits_ahead} "
                else
                    if [[ $commits_behind -gt 0 ]]; then
                        prompt="${prompt}${omg_on} -${commits_behind} ${omg_can_fast_forward_symbol} "
                    fi
                    if [[ $commits_ahead -gt 0 ]]; then
                        prompt="${prompt}${omg_on} ${omg_should_push_symbol} +${commits_ahead} "
                    fi
                fi
                prompt="${prompt}(${green}${current_branch}${reset} ${type_of_upstream} ${upstream//\/$current_branch/})"
            else
                prompt="${prompt}${omg_on}(${green}${current_branch}${reset})"
            fi
        fi
        
        if [[ $omg_display_tag == true && $is_on_a_tag == true ]]; then
            prompt="${prompt} ${yellow}${omg_is_on_a_tag_symbol}${reset}"
        fi
        if [[ $omg_display_tag_name == true && $is_on_a_tag == true ]]; then
            prompt="${prompt} ${yellow}[${tag_at_current_commit}]${reset}"
        fi
        prompt="${prompt}      "
    fi
    
    if [[ $omg_two_lines == true && $is_a_git_repo == true ]]; then
        break='\n'
    else
        break=''
    fi
    
    echo "${prompt}${reset}${break}${omg_finally}${reset}"
}
