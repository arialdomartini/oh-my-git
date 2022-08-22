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

    declare -A colors=(
        ["black"]=30
        ["red"]=31
        ["green"]=32
        ["yellow"]=33
        ["blue"]=34
        ["purple"]=35
        ["cyan"]=36
        ["white"]=37
    )

    declare -A backgrounds=(
        ["black"]=40
        ["red"]=41
        ["green"]=42
        ["yellow"]=43
        ["blue"]=44
        ["purple"]=45
        ["cyan"]=46
        ["white"]=47
    )

    if [ ${#OMG_THEME[@]} -eq 0 ]; then
       declare -A OMG_THEME
    fi

    #Assign default theme colors if they are not already defined in ~/.bashrc
    [ ! ${OMG_THEME["left_side_color"]+abc} ]  && OMG_THEME["left_side_color"]="black"
    [ ! ${OMG_THEME["left_side_bg"]+abc} ]     && OMG_THEME["left_side_bg"]="white"
    [ ! ${OMG_THEME["left_icon_color"]+abc} ]  && OMG_THEME["left_icon_color"]="red"
    [ ! ${OMG_THEME["stash_color"]+abc} ]      && OMG_THEME["stash_color"]="yellow"
    [ ! ${OMG_THEME["right_side_color"]+abc} ] && OMG_THEME["right_side_color"]="black"
    [ ! ${OMG_THEME["right_side_bg"]+abc} ]    && OMG_THEME["right_side_bg"]="red"
    [ ! ${OMG_THEME["right_icon_color"]+abc} ] && OMG_THEME["right_icon_color"]="white"
    [ ! ${OMG_THEME["default_bg"]+abc} ]       && OMG_THEME["default_bg"]="black"

    function enrich_append {
        local flag=$1
        local symbol=$2
        local color=${3:-$omg_default_color_on}
        if [[ $flag == false ]]; then symbol=' '; fi

        echo -n "${color}${symbol}  "
    }

    function get_color {
        local color=${colors[$1]}
        local background=${backgrounds[$2]}
        local attr=${3:-0}
        echo "\e[${attr};${color};${background}m"
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

        local reset='\e[0m'     # Text Reset]'

        #Theme Variables: Text Color + Background
        local left_side=$(get_color ${OMG_THEME["left_side_color"]} ${OMG_THEME["left_side_bg"]})
        local left_icon=$(get_color ${OMG_THEME["left_icon_color"]} ${OMG_THEME["left_side_bg"]})
        local stash=$(get_color ${OMG_THEME["stash_color"]} ${OMG_THEME["left_side_bg"]})
        local right_side=$(get_color ${OMG_THEME["right_side_color"]} ${OMG_THEME["right_side_bg"]})
        local right_icon=$(get_color ${OMG_THEME["right_icon_color"]} ${OMG_THEME["right_side_bg"]})
        local omg_last_symbol_color=$(get_color ${OMG_THEME["right_side_bg"]} ${OMG_THEME["default_bg"]})

        if [[ $is_a_git_repo == true ]]; then
            # on filesystem
            prompt="${left_side}"
            prompt+=$(enrich_append $is_a_git_repo $omg_is_a_git_repo_symbol "${left_side}")
            prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${stash}")

            prompt+=$(enrich_append $has_untracked_files $omg_has_untracked_files_symbol "${left_icon}")
            prompt+=$(enrich_append $has_modifications $omg_has_modifications_symbol "${left_icon}")
            prompt+=$(enrich_append $has_deletions $omg_has_deletions_symbol "${left_icon}")

            # ready
            prompt+=$(enrich_append $has_adds $omg_has_adds_symbol "${left_side}")
            prompt+=$(enrich_append $has_modifications_cached $omg_has_cached_modifications_symbol "${left_side}")
            prompt+=$(enrich_append $has_deletions_cached $omg_has_cached_deletions_symbol "${left_side}")

            # next operation

            prompt+=$(enrich_append $ready_to_commit $omg_ready_to_commit_symbol "${left_icon}")

            # where

            prompt="${prompt} ${right_icon} ${right_side}"
            if [[ $detached == true ]]; then
                prompt+=$(enrich_append $detached $omg_detached_symbol "${right_icon}")
                prompt+=$(enrich_append $detached "(${current_commit_hash:0:7})" "${right_side}")
            else
                if [[ $has_upstream == false ]]; then
                    prompt+=$(enrich_append true "-- ${omg_not_tracked_branch_symbol}  --  (${current_branch})" "${right_side}")
                else
                    if [[ $will_rebase == true ]]; then
                        local type_of_upstream=$omg_rebase_tracking_branch_symbol
                    else
                        local type_of_upstream=$omg_merge_tracking_branch_symbol
                    fi

                    if [[ $has_diverged == true ]]; then
                        prompt+=$(enrich_append true "-${commits_behind} ${omg_has_diverged_symbol} +${commits_ahead}" "${right_icon}")
                    else
                        if [[ $commits_behind -gt 0 ]]; then
                            prompt+="${right_side}-${commits_behind} ${right_icon}${omg_can_fast_forward_symbol}${right_side} --"
                        fi
                        if [[ $commits_ahead -gt 0 ]]; then
                            prompt+="${right_side}-- ${right_icon}${omg_should_push_symbol}${right_side}  +${commits_ahead}"
                        fi
                        if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
                            prompt+="${right_side} --   -- "
                        fi

                    fi
                    prompt+="${right_side}(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})"
                fi
            fi
            prompt+=$(enrich_append ${is_on_a_tag} "${omg_is_on_a_tag_symbol} ${tag_at_current_commit}" "${right_side}")
            prompt+="${omg_last_symbol_color}${reset}\n"
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_second_line}"
        else
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_ungit_prompt}"
        fi
        echo "${prompt}"
    }
    
    PS2="\e[0;33m→${reset} "

    function bash_prompt() {
        PS1="$(build_prompt)"
    }

    PROMPT_COMMAND="bash_prompt; $PROMPT_COMMAND_ORG"

fi
