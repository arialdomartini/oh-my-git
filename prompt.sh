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
    : ${on='\[\033[1;37m\]'}
    : ${off='\[\033[0m\]'}
    : ${red='\[\033[0;31m\]'}
    : ${green='\[\033[0;32m\]'}
    : ${yellow='\[\033[1;33m\]'}
    : ${violet='\[\033[0;35m\]'}
    : ${branch_color='\[\033[1;34m\]'}
    : ${reset='\[\033[0m\]'}

    PS2="${yellow}→${reset} "

    source ${DIR}/base.sh
    function bash_prompt() {
        PS1="$(build_prompt)"
    }

    PROMPT_COMMAND=bash_prompt
fi
