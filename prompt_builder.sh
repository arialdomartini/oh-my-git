function build_prompt() {
	local git_prompt="$(oh_my_git_info)";
	if [[ $two_lines == true && -n $git_prompt ]]; then
        git_prompt=$git_prompt"\n"
    fi
	
	echo "$git_prompt${reset}${finally}"
}
