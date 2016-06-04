#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

SCRIPT_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"
TOP_DIR="$SCRIPT_DIR/.."

DRUSH_DEFAULT_DIR="$HOME/.drush"
DRUSH_DIR="$DRUSH_DEFAULT_DIR"

DRUSH_DEFAULT_BRANCH="8.1.2"
DRUSH_BRANCH="$DRUSH_DEFAULT_BRANCH"

DEFAULT_BIN_DIR="$HOME/bin"
BIN_DIR="$DEFAULT_BIN_DIR"

#-------------------------------------------------------------------------------
# Property initialization

while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -d|--dir)
      DRUSH_DIR="$2"
      shift
    ;;
    -r|--branch)
      DRUSH_BRANCH="$2"
      shift
    ;;
    -b|--bin)
      BIN_DIR="$2"
      shift
    ;;
    -h|--help)
      message="
 Usage: ./drush-init.sh [ -h ] [ --dir {drush directory} ] [ --branch {git branch} ]
 
   -h | --help      |  Display this help message
   -d | --dir       |  Specify the directory in which Drush will be downloaded. (default: $DRUSH_DIR)  
                       -> NOTE: This directory will be deleted if it exists then recreated.
   -r | --branch    |  Specify the Git Drush branch to install from (default: $DRUSH_BRANCH)
   -b | --bin       |  Specify the bin directory where the executable Composer will live. (default: $BIN_DIR)  
                       -> NOTE: This directory will be created if it does not already exist.
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

#---

if [ "$DRUSH_DIR" != "$DRUSH_DEFAULT_DIR" ]; then
  echo "Drush directory: $DRUSH_DIR"
else
  echo "Drush directory (override with -d|--dir): $DRUSH_DIR"
fi

if [ "$DRUSH_BRANCH" != "$DRUSH_DEFAULT_BRANCH" ]; then
  echo "Drush branch: $DRUSH_BRANCH"
else
  echo "Drush branch (override with -r|--branch): $DRUSH_BRANCH"
fi

if [ "$BIN_DIR" != "$DEFAULT_BIN_DIR" ]; then
  echo "Bin directory: $BIN_DIR"
else
  echo "Bin directory (override with -b|--bin): $BIN_DIR"
fi

#-------------------------------------------------------------------------------
# Begin

# Fetch the drush repository
rm -Rf "$DRUSH_DIR"
git clone -b "$DRUSH_BRANCH" https://github.com/drush-ops/drush.git "$DRUSH_DIR"
cd "$DRUSH_DIR"

# Ensure composer is installed
"$SCRIPT_DIR/composer-init.sh" -d "$DRUSH_DIR" -b "$BIN_DIR"

# Run composer install
composer install

# Link drush executable to path
rm -f "$BIN_DIR/drush"
ln -s "$DRUSH_DIR/drush" "$BIN_DIR/drush"

echo "Successfully installed Drush"
