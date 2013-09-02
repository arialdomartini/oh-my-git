function enrich {
    flag=$1
    symbol=$2
    if [[ $flag == "true" ]]
    then
	color="${on}"
    else
	color="${off}"
    fi
    PS1="${PS1}${color}${symbol} "
}
function enrich_if_not_null {
    symbol=$1
    variable=$2
    flag=false
    if [[ -n "$variable" ]]
    then
        flag="true"
    else
	flag="false"
    fi
    enrich "${flag}" "${symbol}"
}

function enrich_if_equal {
    symbol=$1
    variable=$2
    condition=$3
    if [[ $variable == "${condition}" ]]
    then
        flag="true"
    else
	flag="false"
    fi
    enrich "${flag}" "${symbol}"
}

function enrich_if_greater_than_zero {
    symbol=$1
    variable=$2
    if [[ $variable -gt 0 ]]
    then
        flag="true"
    else
	flag="false"
    fi
    enrich "${flag}" "${symbol}"
}

function build_prompt {
    PS1=""
    off="\[\033[1;30m\]"
    on="\[\033[0;37m\]"
    branch_color="\[\033[0;34m\]"
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

    #PS1="${PS1} - ${on}${current_branch}"
    PS1="${PS1}${reset} :"

}


#PREVIOUS_PROMPT=$PS1
PROMPT_COMMAND=build_prompt
