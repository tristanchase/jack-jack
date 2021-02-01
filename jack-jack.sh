#!/usr/bin/env bash
# This script should be sourced
#-----------------------------------

#//Usage: jack-jack <dir>
#//Description: Teleports from one directory to another in your home directory
#//tree. <dir> is the last/directory/in/the/path/<dir>
#//This script should be sourced by typing ". jack-jack <arg>" or creating an
#//alias such as alias go='. jack-jack'
#//Example: jack-jack foo; jack-jack "file name"

# Created: 2020-08-08T21:41:21-04:00
# Tristan M. Chase <tristan.m.chase@gmail.com>

#-----------------------------------
# Save current $IFS for return to shell
OLDIFS=$IFS
IFS=$'\n'

# Only set this if your $SHELL is bash
if [[ $SHELL = $(which bash) ]]; then
	shopt -s globstar
fi

# Generate a list of directories, weed out ., .., and .cache, and match the ones that end with <arg>
_dot_dirs=( $(printf "%b\n" ${HOME}/.*/**/ | grep -Ev '/\.(\.|cache)?/' | sed 's/\/$//g') )
_raw_dirs=( $(printf "%b\n" ${HOME}/**/ | sed 's/\/$//g') )
_raw_dirs=(${_raw_dirs[@]} ${_dot_dirs[@]})
_chooser_array=( $(printf "%b\n" "${_raw_dirs[@]}" | grep -E "${1}"$) )

# If there is more than one match, generate a numbered list and allow user to select by number
#_count="$(printf "%b\n" "${_chooser_array[@]}" | wc -l)"
_count="${#_chooser_array[@]}"
_array_keys=(${!_chooser_array[@]})
function __message__ {
	printf "%q %q\n" $((_key + 1)) "${_chooser_array[$_key]}"
}
_command="cd"

if [[ -z "${_chooser_array}" ]]; then
	printf "%b\n" "\"${1}\" not found."
	return
fi

if [[ $_count -gt 1 ]]; then
	for _key in "${_array_keys[@]}"; do
		#printf "%q %q\n" $((_key + 1)) "${_chooser_array[$_key]}"
		__message__
	done
	#printf "%b\n" "${_chooser_array[@]}" | sed = | sed 'N;s/\n/ /' | more
	printf "Choose file to open (enter number 1-"${_count}", anything else quits): "
	read _number
	case "${_number}" in
		''|*[!0-9]*) # not a number
			return 0
			;;
		*) # not in range
			if [[ "${_number}" -lt 1 ]] || [[ "${_number}" -gt "${_count}" ]]; then
				return 0
			fi
			;;
	esac
	#cd "$(printf "%b\n" "${_chooser_array[@]:$_number-1:1}")"
	"${_command}" "$(printf "%b\n" "${_chooser_array[@]:$_number-1:1}")"
else
	#cd "$(printf "%b\n" "${_chooser_array}")"
	"${_command}" "$(printf "%b\n" "${_chooser_array}")"
fi

# Leave variables in their original state upon return
IFS=$OLDIFS

unset -v _dot_dirs _raw_dirs _chooser_array _count _number

return 0

