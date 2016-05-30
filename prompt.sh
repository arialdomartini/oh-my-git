PSORG=$PS1;
PROMPT_COMMAND_ORG=$PROMPT_COMMAND;

if [ -n "${BASH_VERSION}" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source ${DIR}/base.sh

    : ${omg_ungit_prompt:=$PS1}
    : ${omg_second_line:=$PS1}

    : ${omg_is_a_git_repo_symbol:=''}
    : ${omg_has_untracked_files_symbol:=''}        #                ?    
    : ${omg_has_adds_symbol:=''}
    : ${omg_has_deletions_symbol:=''}
    : ${omg_has_cached_deletions_symbol:=''}
    : ${omg_has_modifications_symbol:=''}
    : ${omg_has_cached_modifications_symbol:=''}
    : ${omg_ready_to_commit_symbol:=''}            #   →
    : ${omg_is_on_a_tag_symbol:=''}                #   
    : ${omg_needs_to_merge_symbol:='ᄉ'}
    : ${omg_detached_symbol:=''}
    : ${omg_can_fast_forward_symbol:=''}
    : ${omg_has_diverged_symbol:=''}               #   
    : ${omg_not_tracked_branch_symbol:=''}
    : ${omg_rebase_tracking_branch_symbol:=''}     #   
    : ${omg_merge_tracking_branch_symbol:=''}      #  
    : ${omg_should_push_symbol:=''}                #    
    : ${omg_has_stashes_symbol:=''}

    : ${omg_default_color_on:='\[\033[1;37m\]'}
    : ${omg_default_color_off:='\[\033[0m\]'}
    : ${omg_last_symbol_color:='\e[0;31m\e[40m'}
    
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
        local enabled=${1}
        local current_commit_hash=${2}
        local is_a_git_repo=${3}
        local current_branch=$4
        local detached=${5}
        local just_init=${6}
        local has_upstream=${7}
        local has_modifications=${8}
        local has_modifications_cached=${9}
        local has_adds=${10}
        local has_deletions=${11}
        local has_deletions_cached=${12}
        local has_untracked_files=${13}
        local ready_to_commit=${14}
        local tag_at_current_commit=${15}
        local is_on_a_tag=${16}
        local has_upstream=${17}
        local commits_ahead=${18}
        local commits_behind=${19}
        local has_diverged=${20}
        local should_push=${21}
        local will_rebase=${22}
        local has_stashes=${23}

        local prompt=""
        local original_prompt=$PS1


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
            prompt="${black_on_white} "
            prompt+=$(enrich_append $is_a_git_repo $omg_is_a_git_repo_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${yellow_on_white}")

            prompt+=$(enrich_append $has_untracked_files $omg_has_untracked_files_symbol "${red_on_white}")
            prompt+=$(enrich_append $has_modifications $omg_has_modifications_symbol "${red_on_white}")
            prompt+=$(enrich_append $has_deletions $omg_has_deletions_symbol "${red_on_white}")
            

            # ready
            prompt+=$(enrich_append $has_adds $omg_has_adds_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_modifications_cached $omg_has_cached_modifications_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_deletions_cached $omg_has_cached_deletions_symbol "${black_on_white}")
            
            # next operation

            prompt+=$(enrich_append $ready_to_commit $omg_ready_to_commit_symbol "${red_on_white}")

            # where

            prompt="${prompt} ${white_on_red} ${black_on_red}"
            if [[ $detached == true ]]; then
                prompt+=$(enrich_append $detached $omg_detached_symbol "${white_on_red}")
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
            prompt+=$(enrich_append ${is_on_a_tag} "${omg_is_on_a_tag_symbol} ${tag_at_current_commit}" "${black_on_red}")
            prompt+="${omg_last_symbol_color}${reset}\n"
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_second_line}"
        else
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_ungit_prompt}"
        fi

        echo "${prompt}"
    }
    
    PS2="${yellow}→${reset} "

    function bash_prompt() {
        PS1="$(build_prompt)"
    }

    PROMPT_COMMAND="bash_prompt; $PROMPT_COMMAND_ORG"

fi
