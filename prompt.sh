PSORG=$PS1;PROMPT_COMMAND_ORG=$PROMPT_COMMAND;

if [ -n "${BASH_VERSION}" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source ${DIR}/base.sh

    : ${omg_condensed:=false}
    : ${omg_ungit_prompt:=$PS1}
    : ${omg_second_line:=$PS1}

    : ${omg_is_a_git_repo_symbol:=''}
    : ${omg_submodules_outdated_symbol:=''}
    : ${omg_has_untracked_files_symbol:=''}        #                ?    
    : ${omg_has_adds_symbol:=''}
    : ${omg_has_deletions_symbol:=''}
    : ${omg_has_cached_deletions_symbol:=''}
    : ${omg_has_renames_symbol:=''}                # 
    : ${omg_has_modifications_symbol:=''}
    : ${omg_has_cached_modifications_symbol:=''}
    : ${omg_ready_to_commit_symbol:=''}            #   →
    : ${omg_is_on_a_tag_symbol:=''}                #       
    : ${omg_needs_to_merge_symbol:=''}             # ᄉ
    : ${omg_detached_symbol:=''}                  #   
    : ${omg_can_fast_forward_symbol:=''}
    : ${omg_has_diverged_symbol:=''}               #   
    : ${omg_not_tracked_branch_symbol:=''}        #   
    : ${omg_rebase_tracking_branch_symbol:=''}     #   
    : ${omg_rebase_interactive_symbol:=''}
    : ${omg_bisect_symbol:=''}
    : ${omg_bisect_close_symbol:=''}
    : ${omg_bisect_done_symbol:=''}
    : ${omg_merge_tracking_branch_symbol:=''}      #  
    : ${omg_should_push_symbol:=''}                #    
    : ${omg_has_stashes_symbol:=''}
    : ${omg_arrow_symbol:=''}
    : ${omg_is_virtualenv_symbol:=''}

    : ${omg_default_color_on:='\[\033[1;37m\]'}
    : ${omg_default_color_off:='\[\033[0m\]'}

    PROMPT='$(build_prompt)'
    RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'

    function enrich_append {
        local flag=$1
        local symbol=$2
        local color=${3:-$omg_default_color_on}
        if [[ $flag == false ]]; then symbol=' '; fi

        echo -n "${color}${symbol}  "
    }

    function custom_build_prompt {
        local enabled=${1}; shift 1;
        local current_commit_hash=${1}; shift 1;
        local is_a_git_repo=${1}; shift 1;
        local current_branch=${1}; shift 1;
        local detached=${1}; shift 1;
        local just_init=${1}; shift 1;
        local has_upstream=${1}; shift 1;
        local has_modifications=${1}; shift 1;
        local has_modifications_cached=${1}; shift 1;
        local has_adds=${1}; shift 1;
        local has_deletions=${1}; shift 1;
        local has_deletions_cached=${1}; shift 1;
        local has_renames=${1}; shift 1;
        local has_untracked_files=${1}; shift 1;
        local ready_to_commit=${1}; shift 1;
        local tags_at_current_commit=${1}; shift 1;
        local has_upstream=${1}; shift 1;
        local commits_ahead=${1}; shift 1;
        local commits_behind=${1}; shift 1;
        local has_diverged=${1}; shift 1;
        local should_push=${1}; shift 1;
        local will_rebase=${1}; shift 1;
        local has_stashes=${1}; shift 1;
        local bisect_remain=${1}; shift 1;
        local bisect_total=${1}; shift 1;
        local bisect_steps=${1}; shift 1;
        local submodules_outdated=${1}; shift 1;
        local action=${1}; shift 1;

        local prompt=""
        local original_prompt=$PS1

        local is_virtualenv="${VIRTUAL_ENV:-false}"
        if [[ $is_virtualenv != false ]]; then
            local virtualenv=$(basename $VIRTUAL_ENV)
        fi


        # foreground
        local black='\e[0;30m'
        local red='\e[0;31m'
        local green='\e[0;32m'
        local yellow='\e[0;33m'
        local blue='\e[0;34m'
        local purple='\e[0;35m'
        local cyan='\e[0;36m'
        local white='\e[0;37m'

        #background
        local background_black='\e[40m'
        local background_red='\e[41m'
        local background_green='\e[42m'
        local background_yellow='\e[43m'
        local background_blue='\e[44m'
        local background_purple='\e[45m'
        local background_cyan='\e[46m'
        local background_white='\e[47m'

        local reset='\e[0m'     # Text Reset]'

        local black_on_white="${black}${background_white}"
        local yellow_on_white="${yellow}${background_white}"
        local red_on_white="${red}${background_white}"
        local red_on_black="${red}${background_black}"
        local black_on_red="${black}${background_red}"
        local white_on_red="${white}${background_red}"
        local yellow_on_red="${yellow}${background_red}"


        # Flags
        local omg_default_color_on="${black_on_white}"

        if [[ $is_a_git_repo == true ]]; then
            # on filesystem
            if [[ $submodules_outdated == true ]]; then
                repo_status_symbol=$omg_submodules_outdated_symbol
            else
                repo_status_symbol=$omg_is_a_git_repo_symbol
            fi
            prompt="${black_on_white} "
            prompt+=$(enrich_append $is_a_git_repo $repo_status_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${black_on_white}")

            prompt+=$(enrich_append $has_untracked_files $omg_has_untracked_files_symbol "${red_on_white}")
            prompt+=$(enrich_append $has_modifications $omg_has_modifications_symbol "${red_on_white}")
            prompt+=$(enrich_append $has_deletions $omg_has_deletions_symbol "${red_on_white}")


            # ready
            if [[ ${omg_condensed} == true && ${has_adds} == true ]]; then
                has_modifications_cached=true
            fi
            if [[ ${omg_condensed} == true && ${has_deletions_cached} == true ]]; then
                has_modifications_cached=true
            fi
            if [[ ${omg_condensed} == true && ${has_renames} == true ]]; then
                has_modifications_cached=true
            fi
            if [[ ${omg_condensed} == false ]]; then
                prompt+=$(enrich_append $has_adds $omg_has_adds_symbol $omg_has_renames_symbol "${black_on_white}")
            fi
            prompt+=$(enrich_append $has_modifications_cached $omg_has_cached_modifications_symbol "${black_on_white}")
            if [[ ${omg_condensed} == false ]]; then
                prompt+=$(enrich_append $has_deletions_cached $omg_has_cached_deletions_symbol "${black_on_white}")
            fi

            # next operation

            prompt+=$(enrich_append $ready_to_commit $omg_ready_to_commit_symbol "${red_on_white}")

            # where

            prompt="${prompt} ${white_on_red}${omg_arrow_symbol} ${black_on_red}"
            if [[ $detached == true ]]; then
                if [[ "${action}" = "rebase" ]]; then
                    prompt+=$(enrich_append $detached $omg_rebase_interactive_symbol "${white_on_red}")
                elif [[ "${action}" = "bisect" ]] && [[ "${bisect_steps}" = "0" ]]; then
                    prompt+=$(enrich_append $detached "$omg_bisect_done_symbol" "${white_on_red}")
                elif [[ "${action}" = "bisect" ]] && [[ "${bisect_steps}" = "~0" ]]; then
                    prompt+=$(enrich_append $detached "${bisect_tested}/${bisect_total} $omg_bisect_close_symbol  ${bisect_steps}" "${white_on_red}")
                elif [[ "${action}" = "bisect" ]]; then
                    prompt+=$(enrich_append $detached "${bisect_tested}/${bisect_total} $omg_bisect_symbol  ${bisect_steps}" "${white_on_red}")
                else
                    prompt+=$(enrich_append $detached $omg_detached_symbol "${white_on_red}")
                fi
                prompt+=$(enrich_append $detached "(${current_commit_hash:0:7})" "${black_on_red}")
            else
                if [[ $has_upstream == false ]]; then
                    prompt+=$(enrich_append true "-- ${omg_not_tracked_branch_symbol}  --  (${current_branch})" "${black_on_red}")
                else
                    if [[ $will_rebase == true ]]; then
                        local type_of_upstream=$omg_rebase_tracking_branch_symbol
                    else
                        local type_of_upstream=$omg_merge_tracking_branch_symbol
                    fi

                    if [[ $has_diverged == true ]]; then
                        prompt+=$(enrich_append true "-${commits_behind} ${omg_has_diverged_symbol} +${commits_ahead}" "${white_on_red}")
                    else
                        if [[ $commits_behind -gt 0 ]]; then
                            prompt+=$(enrich_append true "-${commits_behind} ${white_on_red}${omg_can_fast_forward_symbol}${black_on_red} --" "${black_on_red}")
                        fi
                        if [[ $commits_ahead -gt 0 ]]; then
                            prompt+=$(enrich_append true "-- ${white_on_red}${omg_should_push_symbol}${black_on_red}  +${commits_ahead}" "${black_on_red}")
                        fi
                        if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
                            prompt+=$(enrich_append true " --   -- " "${black_on_red}")
                        fi

                    fi
                    prompt+=$(enrich_append true "(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})" "${black_on_red}")
                fi
            fi
            for tag in ${tags_at_current_commit}; do
                prompt+=$(enrich_append true "${omg_is_on_a_tag_symbol} ${tag}" "${black_on_red}")
            done
            prompt+=$(enrich_append ${is_virtualenv} "${omg_is_virtualenv_symbol}  ${virtualenv}" "${white_on_red}")
            prompt+="${reset}${red}${omg_arrow_symbol}${reset}\n"
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_second_line}"
        else
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_ungit_prompt}"
            if [[ $is_virtualenv != false ]]; then
                prompt+="${virtualenv}${omg_is_virtualenv_symbol}  "
            fi
        fi

        echo "${prompt}"
    }

    PS2="${yellow}→${reset} "

    function bash_prompt() {
        PS1="$(build_prompt)"
    }

    PROMPT_COMMAND="bash_prompt; $PROMPT_COMMAND_ORG"

fi
