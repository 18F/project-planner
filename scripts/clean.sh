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

rm -Rf drush/contrib
rm -Rf vendor

rm -Rf web/core
rm -Rf web/modules/contrib
rm -Rf web/themes/contrib
rm -Rf web/profiles/contrib
rm -Rf web/libraries

echo "Successfully cleaned all Drupal application build files"
