#!/bin/bash

echo "PWD: $(pwd)"
echo
echo "BASH_SOURCE: ${BASH_SOURCE[0]}"
echo
echo "SCRIPT_DIR: $( dirname "${BASH_SOURCE[0]}" )"
echo

#
# cd && pwd combo converts relative paths into absolute paths, making it safe in all cases.
# otherwise, ALWAYS_SAME_SCRIPT_DIR becomes `.` / dot.
# which is not helpful if I am running the script from a different directory.
#
# this will always point to where the script actually lives on disk.
#
ALWAYS_SAME_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "ALWAYS_SAME_SCRIPT_DIR: $ALWAYS_SAME_SCRIPT_DIR"
