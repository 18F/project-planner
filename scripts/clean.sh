#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

SCRIPT_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"
TOP_DIR="$SCRIPT_DIR/.."

#-------------------------------------------------------------------------------
# Property initialization

while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -h|--help)
      message="
 Usage: ./clean.sh [ -h ]
 
   -h | --help  |  Display this help message
"
      echo "$message"
      exit 0
    ;;
    *)
      # unknown option
    ;;
  esac
  shift
done

#-------------------------------------------------------------------------------
# Begin

# Clean application build files
cd "$TOP_DIR"

rm -f "composer.lock"  # Do I really delete this?
rm -Rf "vendor"
rm -Rf "htdocs"

echo "Successfully cleaned all Drupal application build files"
