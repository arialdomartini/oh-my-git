function enrich_if_not_null {
    symbol=$1
    variable=$2
    if [[ -z "$variable" ]]
    then
        flag=${off}
    else
        flag=${on}
    fi
    PS1="${PS1} ${flag}${symbol}"
}

function enrich_if_equal {
    symbol=$1
    variable=$2
    condition=$3
    if [[ $variable == "${condition}" ]]
    then
        flag=${on}
    else
        flag=${off}
    fi
    PS1="${PS1} ${flag}${symbol}"
}

function enrich_if_greater_than_zero {
    symbol=$1
    variable=$2
    if [[ $variable -gt 0 ]]
    then
        flag=${on}
    else
        flag=${off}
    fi
    PS1="${PS1} ${flag}${symbol}"
}
function build_prompt {
    PS1=""
    on="\[\033[1;37m\]"
    off="\[\033[0;30m\]"
    blinking="\[\033[1;5;17m\]"
    reset="\[\033[0m\]"

    current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    enrich_if_not_null "❤" $current_branch
    enrich_if_equal "⚯" "${current_branch}" "HEAD"

    number_of_modifications=$(git status --short 2> /dev/null|grep --count -e ^\.M)
    enrich_if_greater_than_zero "✎" "${number_of_modifications}"

    number_of_modifications_cached=$(git status --short 2> /dev/null|grep --count -e ^M)
    enrich_if_greater_than_zero "→" "${number_of_modifications_cached}"

    number_of_untracked=$(git status --short 2> /dev/null|grep --count -e ^\?\?)
    enrich_if_greater_than_zero "∿" "${number_of_untracked}"


    PS1="${PS1}${reset} ${current_branch}:"
}


#PREVIOUS_PROMPT=$PS1
PROMPT_COMMAND=build_prompt
