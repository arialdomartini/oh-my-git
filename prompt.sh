if [ -n "${BASH_VERSION}" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
    : ${print_unactive_flags_space:=true}
    : ${display_git_symbol:=true}

    # Colors
    # Bash unprintable characters must be wrapped inside \[ and \]
    # http://mywiki.wooledge.org/BashFAQ/053
    : ${omg_on='\[\e[0;37m\]'}
    : ${omg_off='\[\e[1;30m\]'}
    : ${omg_red='\[\e[0;31m\]'}
    : ${omg_green='\[\e[0;32m\]'}
    : ${omg_yellow='\[\e[0;33m\]'}
    : ${omg_violet='\[\e[0;35m\]'}
    : ${omg_branch_color='\e[0;34m\]'}
    : ${omg_reset='\[\e[0m\]'}
    
    PS2="${omg_yellow}→${omg_reset} "
    
    source ${DIR}/git-info.sh
    source ${DIR}/prompt_builder.sh

    function bash_prompt() {
        PS1="$(build_prompt)"
    }

    PROMPT_COMMAND=bash_prompt
fi
