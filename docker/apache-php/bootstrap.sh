#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

SCRIPT_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"

DEFAULT_PROJECT_DIR="/var/www"
PROJECT_DIR="$DEFAULT_PROJECT_DIR"

#-------------------------------------------------------------------------------
# Property initialization

while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -d|--dir)
      PROJECT_DIR="$2"
      shift
    ;;
    -h|--help)
      message="
 Usage: bootstrap [ -h ]
 
   -h | --help      |  Display this help message
   -d | --dir       |  Specify the root project directory. (default: $PROJECT_DIR)  
                       -> NOTE: This directory must already exist.
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

if [ "$PROJECT_DIR" != "$DEFAULT_PROJECT_DIR" ]; then
  echo "Root project directory: $PROJECT_DIR"
else
  echo "Root project directory (override with -d|--dir): $PROJECT_DIR"
fi

#-------------------------------------------------------------------------------
# Begin

# This needs to be defined so Composer knows where to find our configuration overrides
export DOCKER_IMAGE="apache-php"

# Build project and fetch dependencies
composer install -n -d "$PROJECT_DIR"

# Initialize Apache environment
: "${APACHE_CONFDIR:=/etc/apache2}"
: "${APACHE_ENVVARS:=$APACHE_CONFDIR/envvars}"
if test -f "$APACHE_ENVVARS"; then
  . "$APACHE_ENVVARS"
fi

# Apache gets grumpy about PID files pre-existing
: "${APACHE_PID_FILE:=${APACHE_RUN_DIR:=/var/run/apache2}/apache2.pid}"
rm -f "$APACHE_PID_FILE"

# Execute Apache web server in the foreground
cd "$PROJECT_DIR"
exec apache2 -DFOREGROUND
