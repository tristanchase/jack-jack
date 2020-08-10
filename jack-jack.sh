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

dot_dirs=( $(for i in $(printf '%b\n' ~/.*/. | sed 's/\/\.$//g' | grep -v "\."$); do printf '%b\n' "$i"*/**/. | sed 's/\/\.$//g'; done) )
raw_dirs=( $(printf '%b\n' ~/**/. | sed 's/\/\.//g') )
raw_dirs=(${raw_dirs[@]} ${dot_dirs[@]})
#raw_dirs=( $(printf '%b\n' ~/**/. ~/.**/**/. | sed 's/\/\.//g') )
dirs=( $(printf '%b\n' "${raw_dirs[@]}" | grep -E "${1}"$) )

count="$(printf '%b\n' "${dirs[@]}" | wc -l)"
if [[ $count -gt 1 ]]; then
#	if [[ $SHELL = $(which bash) ]]; then
#		for i in "${!dirs[@]}"; do
#			printf '%s %s\n' "$i" "${dirs[$i]}"
#		done
#	else
		printf '%b\n' "${dirs[@]}" | sed = | sed 'N;s/\n/ /'
#	fi
	printf "Choose directory (enter number): "
	read number # handle incorrect input here
	cd "$(printf '%b\n' "${dirs[@]:$number-1:1}")"
else
	cd "$(printf '%b\n' "${dirs}")"
fi

IFS=$OLDIFS

return

