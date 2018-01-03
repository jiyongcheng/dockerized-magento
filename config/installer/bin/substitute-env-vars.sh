#!/bin/bash
#-e Exit immediately if a command exits with a non-zero exit status.
#-u Treat unset variables as an error when substituting.
set -eu

# $# is the number of arguments
output_dir=$1
# about shift http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_07.html
shift
# set the files-to-search to the args passed.
files=$@

function fill_in() {
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : "\${$1}"/eg' "${1}"
}

function output_filename {
    local destname=$(basename "${1}" '.tmpl')
    echo "${output_dir}/${destname}"
}

for file in $files; do
    fill_in "${file}" > $(output_filename "${file}")
done
