#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

SCRIPT_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"
TOP_DIR="$SCRIPT_DIR/.."

APP_DEFAULT_NAME="project-planner"
APP_NAME="$APP_DEFAULT_NAME"

APP_DEFAULT_START="start"
APP_START="$APP_DEFAULT_START"

#-------------------------------------------------------------------------------
# Property initialization

while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -n|--name)
      APP_NAME="$2"
      shift
    ;;
    -o|--no-start)
      APP_START="stop"
      shift
    ;;
    -h|--help)
      message="
 Usage: ./cg-deploy.sh [ -h ]
 
   -h | --help       |  Display this help message
   -o | --no-start   |  Create the application and related services but do not start (default: $APP_START)
   -n | --name       |  Specify the name of the drupal application (default: $APP_NAME)
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

if [ "$APP_NAME" != "$APP_DEFAULT_NAME" ]; then
  echo "Drupal application name: $APP_NAME"
else
  echo "Drupal application name (override with -n|--name): $APP_NAME"
fi

if [ "$APP_START" != "$APP_DEFAULT_START" ]; then
  echo "Drupal application state: $APP_START"
else
  echo "Drupal application state (override with -o|--no-start): $APP_START"
fi

#-------------------------------------------------------------------------------
# Begin

# Prepare application (include any custom updates)
cd "$TOP_DIR"
composer install # Rebuild the code base to ensure we have a clean remote copy

# Push application to cloud.gov 
# (but do not start it until we create and attach the services)
if [ "$APP_START" == "start" ]; then
  # Start application
  cf push
else 
  cf push --no-start
fi

echo "Successfully pushed $APP_NAME application"
