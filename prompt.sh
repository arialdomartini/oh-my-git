PSORG=$PS1;

if [ -n "${BASH_VERSION}" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Symbols
    : ${omg_is_a_git_repo_symbol:='❤'}
    : ${omg_has_untracked_files_symbol:='∿'}
    : ${omg_has_adds_symbol:='+'}
    : ${omg_has_deletions_symbol:='-'}
    : ${omg_has_cached_deletions_symbol:='✖'}
    : ${omg_has_modifications_symbol:='✎'}
    : ${omg_has_cached_modifications_symbol:='☲'}
    : ${omg_ready_to_commit_symbol:='→'}
    : ${omg_is_on_a_tag_symbol:='⌫'}
    : ${omg_needs_to_merge_symbol:='ᄉ'}
    : ${omg_has_upstream_symbol:='⇅'}
    : ${omg_detached_symbol:='⚯ '}
    : ${omg_can_fast_forward_symbol:='»'}
    : ${omg_has_diverged_symbol:='Ⴤ'}
    : ${omg_rebase_tracking_branch_symbol:='↶'}
    : ${omg_merge_tracking_branch_symbol:='ᄉ'}
    : ${omg_should_push_symbol:='↑'}
    : ${omg_has_stashes_symbol:='★'}

    # Flags
    : ${omg_display_has_upstream:=false}
    : ${omg_display_tag:=false}
    : ${omg_display_tag_name:=true}
    : ${omg_two_lines:=true}
    : ${omg_finally:='\w ∙ '}
    : ${omg_use_color_off:=false}

    # Colors
    : ${omg_default_color_on='\[\033[1;37m\]'}
    : ${omg_default_color_off='\[\033[0m\]'}
    : ${red='\[\033[0;31m\]'}
    : ${green='\[\033[0;32m\]'}
    : ${yellow='\[\033[1;33m\]'}
    : ${violet='\[\033[0;35m\]'}
    : ${reset='\[\033[0m\]'}

    PS2="${yellow}→${reset} "

    source ${DIR}/base.sh
    function bash_prompt() {
        PS1="$(build_prompt)"
    }

    PROMPT_COMMAND=bash_prompt



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
                    prompt="${prompt} ${omg_default_color_on}(${current_commit_hash:0:7})"
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
                            prompt="${prompt}${omg_default_color_on} -${commits_behind} ${omg_can_fast_forward_symbol} "
                        fi
                        if [[ $commits_ahead -gt 0 ]]; then
                            prompt="${prompt}${omg_default_color_on} ${omg_should_push_symbol} +${commits_ahead} "
                        fi
                    fi
                    prompt="${prompt}(${green}${current_branch}${reset} ${type_of_upstream} ${upstream//\/$current_branch/})"
                else
                    prompt="${prompt}${omg_default_color_on}(${green}${current_branch}${reset})"
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
fi
