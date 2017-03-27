#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

DEFAULT_TEMP_DIR="/tmp"
TEMP_DIR="$DEFAULT_TEMP_DIR"

DEFAULT_BIN_DIR="$HOME/bin"
BIN_DIR="$DEFAULT_BIN_DIR"

#-------------------------------------------------------------------------------
# Property initialization

while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -d|--dir)
      TEMP_DIR="$2"
      shift
    ;;
    -b|--bin)
      BIN_DIR="$2"
      shift
    ;;
    -h|--help)
      message="
Usage: ./composer-init.sh [ -h ] [ --dir {temp directory} ] [ --bin {bin directory} ]
 
   -h | --help      |  Display this help message
   -d | --dir       |  Specify the temp directory in which Composer will be downloaded. (default: $TEMP_DIR)  
                       -> NOTE: This directory must already exist.
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

if [ "$TEMP_DIR" != "$DEFAULT_TEMP_DIR" ]; then
  echo "Temp directory: $TEMP_DIR"
else
  echo "Temp directory (override with -d|--dir): $TEMP_DIR"
fi

if [ "$BIN_DIR" != "$DEFAULT_BIN_DIR" ]; then
  echo "Bin directory: $BIN_DIR"
else
  echo "Bin directory (override with -b|--bin): $BIN_DIR"
fi


#-------------------------------------------------------------------------------
# Begin

# Head over to the tmp directory
cd "$TEMP_DIR"

# Ensure composer is installed
curl -sS https://getcomposer.org/installer | php

mkdir -p "$BIN_DIR"
mv composer.phar "$BIN_DIR/composer"

if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi

echo "Successfully installed Composer"
