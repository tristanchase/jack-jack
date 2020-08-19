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

# Depends on:
#  list
#  of
#  dependencies
#-----------------------------------
OLDIFS=$IFS
IFS=$'\n'

if [[ $SHELL = $(which bash) ]]; then
	shopt -s globstar
fi

dot_dirs=( $(printf '%b\n' ${HOME}/.*/**/ | grep -Ev '/\.(\.|cache)?/' | sed 's/\/$//g') )
raw_dirs=( $(printf '%b\n' ${HOME}/**/ | sed 's/\/$//g') )
raw_dirs=(${raw_dirs[@]} ${dot_dirs[@]})
dirs=( $(printf '%b\n' "${raw_dirs[@]}" | grep -E "${1}"$) )

count="$(printf '%b\n' "${dirs[@]}" | wc -l)"
if [[ $count -gt 1 ]]; then
	printf '%b\n' "${dirs[@]}" | sed = | sed 'N;s/\n/ /' | more
	#printf "Choose directory (enter number): "
	#read number # handle incorrect input here
	printf "Choose file to open (enter number 1-"${count}", anything else quits): "
	read number
	case "${number}" in
		''|*[!0-9]*) # not a number
			return 0
			;;
		*) # not in range
			if [[ "${number}" -lt 1 ]] || [[ "${number}" -gt "${count}" ]]; then
				return 0
			fi
			;;
	esac
	cd "$(printf '%b\n' "${dirs[@]:$number-1:1}")"
else
	cd "$(printf '%b\n' "${dirs}")"
fi

IFS=$OLDIFS

return

