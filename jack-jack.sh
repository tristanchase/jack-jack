#!/usr/bin/env bash
# This script should be sourced
#-----------------------------------

#//Usage: jack-jack <dir>
#//Description: Teleports from one directory to another in your home directory
#//tree. <dir> is the last/directory/in/the/path/<dir>
#//This script should be sourced by typing ". jack-jack <arg>" or creating an
#//alias such as alias go='. jack-jack'
#//Example: jack-jack foo

# Created: 2020-08-08T21:41:21-04:00
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  list
#  of
#  dependencies
#-----------------------------------

if [[ $SHELL = "/usr/bin/bash" ]]; then
	shopt -s globstar
fi

raw_dirs=( $(printf '%q\n' ~/**/. | sed 's/\/\.//' ) ) # handle spaces in file names here
dirs=( $(printf '%b\n' "${raw_dirs[@]}" | grep -E "${1}"$) )

count="$(printf '%b\n' "${dirs[@]}" | wc -l)"
if [[ $count -gt 1 ]]; then
	printf '%b\n' "${dirs[@]}" | sed = | sed 'N;s/\n/ /'
	printf "Choose directory (enter number): "
	read number # handle incorrect input here
	cd $(printf '%b\n' "${dirs[@]:$number-1:1}")
else
	cd "$(printf '%b\n' "${dirs}")"
fi

return
