if [ -n "${BASH_VERSION}" ]; then
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
    : ${on='\033[0;37m'}
    : ${off='\033[1;30m'}
    : ${red='\033[0;31m'}
    : ${green='\033[0;32m'}
    : ${yellow='\033[0;33m'}
    : ${violet='\033[0;35m'}
    : ${branch_color='\033[0;34m'}
    : ${reset='\033[0m'}
    
    PS2="${yellow}→${reset} "
    
    source base.sh
    function bash_prompt() {
        PS1="$(build_prompt)"
    }

    PROMPT_COMMAND=bash_prompt
fi
