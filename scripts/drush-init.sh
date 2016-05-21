#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

DRUSH_DEFAULT_DIR="$HOME/.drush"
DRUSH_DIR="$DRUSH_DEFAULT_DIR"

DRUSH_DEFAULT_BRANCH="8.1.2"
DRUSH_BRANCH="$DRUSH_DEFAULT_BRANCH"

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
    -b|--branch)
      DRUSH_BRANCH="$2"
      shift
    ;;
    -h|--help)
      message="
 Usage: ./drush-init.sh [ -h ] [ --dir {drush directory} ] [ --branch {git branch} ]
 
   -h | --help      |  Display this help message
   -d | --dir       |  Specify the directory in which Drush will be downloaded. (default: $DRUSH_DIR)  
                       -> NOTE: This directory will be deleted if it exists then recreated.
   -b | --branch    |  Specify the Git Drush branch to install from (default: $DRUSH_BRANCH)
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
  echo "Drush branch (override with -b|--branch): $DRUSH_BRANCH"
fi

#-------------------------------------------------------------------------------
# Begin

# Fetch the drush repository
rm -Rf "$DRUSH_DIR"
git clone -b "$DRUSH_BRANCH" https://github.com/drush-ops/drush.git "$DRUSH_DIR"
cd "$DRUSH_DIR"

# Ensure composer is installed
curl -sS https://getcomposer.org/installer | php

mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"

mv composer.phar "$HOME/bin/composer"

# Run composer install
composer install

# Link drush executable to path
rm -f "$HOME/bin/drush"
ln -s "$HOME/.drush/drush" "$HOME/bin/drush"

echo "Successfully installed Drush"
