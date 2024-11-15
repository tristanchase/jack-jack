#!/usr/bin/env bash
# This script should be sourced

#-----------------------------------
function __usage__ {
	cat <<HELP_USAGE
Usage: jack-jack <dir>

Description: Teleports from one directory to another in your home directory
tree. <dir> is the last/directory/in/the/path/<dir>

This script should be sourced by typing ". jack-jack <dir>" or creating an
alias such as alias go='. jack-jack'

Examples: jack-jack foo; jack-jack "file name"
HELP_USAGE
}

# Created: 2020-08-08T21:41:21-04:00
# Tristan M. Chase <tristan.m.chase@gmail.com>

#-----------------------------------
# TODO Section

#<todo>
# TODO
# 1. Rewrite main section
# 	Look to super-grep
# 2. Refactor functions
# 	Look to gen-keys
# * Insert script
# * Clean up stray ;'s
# * Modify command substitution to "$(this_style)"
# * Rename function_name() to function __function_name__ /\w+\(\)
# * Rename $variables to "${_variables}" /\$\w+/s+1 @v vEl,{n
# * Check that _variable="variable definition" (make sure it's in quotes)
# * Update usage, description, and options section
# * Update dependencies section

# DONE

#</todo>

#-----------------------------------
# Save current $IFS for return to shell
OLDIFS=$IFS
IFS=$'\n'

# Only set this if your $SHELL is bash
if [[ $SHELL = $(which bash) ]]; then
	shopt -s globstar
fi

#-----------------------------------
#<main>

# Make sure there is a <dir> to search for; Print usage and exit if <dir> is missing
if [[ -z ${1:-} ]]; then
	__usage__
	return 2
fi

# Generate a list of directories, weed out ., .., and .cache, and match the ones that end with <dir>
_dot_dirs=( $(printf "%b\n" ${HOME}/.*/**/ | grep -Ev '/\.(\.|cache)?/' | sed 's/\/$//g') )
_raw_dirs=( $(printf "%b\n" ${HOME}/**/ | sed 's/\/$//g') )
_raw_dirs=(${_raw_dirs[@]} ${_dot_dirs[@]})
_chooser_array=( $(printf "%b\n" "${_raw_dirs[@]}" | grep -E "${1}"$) )

# If <dir> is not found, warn user and exit
if [[ -z "${_chooser_array}" ]]; then
	printf "%b\n" "\"${1}\" not found."
	return 1
fi

# If there is more than one match, generate a numbered list and allow user to select by number
_chooser_count="${#_chooser_array[@]}"
_chooser_array_keys=(${!_chooser_array[@]})
function __chooser_message__ {
	printf "%q %q\n" $((_key + 1)) "${_chooser_array[$_key]}"
}
_chooser_command="cd"

if [[ $_chooser_count -gt 1 ]]; then
	for _key in "${_chooser_array_keys[@]}"; do
		__chooser_message__
	done | more -e
	printf "Choose file to open (enter number 1-"${_chooser_count}", anything else quits): "
	read _chooser_number
	case "${_chooser_number}" in
		''|*[!0-9]*) # not a number
			return 0
			;;
		*) # not in range
			if [[ "${_chooser_number}" -lt 1 ]] || [[ "${_chooser_number}" -gt "${_chooser_count}" ]]; then
				return 0
			fi
			;;
	esac
	"${_chooser_command}" "$(printf "%b\n" "${_chooser_array[@]:$_chooser_number-1:1}")"
else
	"${_chooser_command}" "$(printf "%b\n" "${_chooser_array}")"
fi

# Leave variables in their original state upon return
IFS=$OLDIFS

unset -v OLDIFS _dot_dirs _raw_dirs _chooser_array _chooser_count _chooser_number _chooser_array_keys _chooser_command _key

return 0
#</main>
