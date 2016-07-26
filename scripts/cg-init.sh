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

DB_DEFAULT_SERVICE_NAME="aws-rds"
DB_SERVICE_NAME="$DB_DEFAULT_SERVICE_NAME"
DB_DEFAULT_SERVICE_PLAN="shared-psql"
DB_SERVICE_PLAN="$DB_DEFAULT_SERVICE_PLAN"

FILES_DEFAULT_SERVICE_NAME="s3" # Right now only S3 supported
FILES_SERVICE_NAME="$FILES_DEFAULT_SERVICE_NAME"
FILES_DEFAULT_SERVICE_PLAN="basic"
FILES_SERVICE_PLAN="$FILES_DEFAULT_SERVICE_PLAN"

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
    -d|--db-name)
      DB_SERVICE_NAME="$2"
      shift
    ;;
    -p|--db-plan)
      DB_SERVICE_PLAN="$2"
      shift
    ;;
    -f|--files-name)
      FILES_SERVICE_NAME="$2"
      shift
    ;;
    -l|--files-plan)
      FILES_SERVICE_PLAN="$2"
      shift
    ;;
    -h|--help)
      message="
 Usage: ./cg-init.sh [ -h ]
 
   -h | --help       |  Display this help message
   -o | --no-start   |  Create the application and related services but do not start (default: $APP_START)
   -n | --name       |  Specify the name of the drupal application (default: $APP_NAME)
   -d | --db-name    |  Specify the name of the drupal application database service (default: $DB_SERVICE_NAME)
   -p | --db-plan    |  Specify a service plan for the drupal application database service (default: $DB_SERVICE_PLAN)
   -f | --files-name |  Specify the name of the drupal application file storage service (default: $FILES_SERVICE_NAME)
   -l | --files-plan |  Specify a service plan for the drupal application file storage service (default: $FILES_SERVICE_PLAN)
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

if [ "$DB_SERVICE_NAME" != "$DB_DEFAULT_SERVICE_NAME" ]; then
  echo "Drupal application database service name: $DB_SERVICE_NAME"
else
  echo "Drupal application database service name (override with -d|--db-name): $DB_SERVICE_NAME"
fi

if [ "$DB_SERVICE_PLAN" != "$DB_DEFAULT_SERVICE_PLAN" ]; then
  echo "Drupal application database service plan: $DB_SERVICE_PLAN"
else
  echo "Drupal application database service plan (override with -p|--db-plan): $DB_SERVICE_PLAN"
fi

if [ "$FILES_SERVICE_NAME" != "$FILES_DEFAULT_SERVICE_NAME" ]; then
  echo "Drupal application file storage service name: $FILES_SERVICE_NAME"
else
  echo "Drupal application file storage service name (override with -f|--files-name): $FILES_SERVICE_NAME"
fi

if [ "$FILES_SERVICE_PLAN" != "$FILES_DEFAULT_SERVICE_PLAN" ]; then
  echo "Drupal application file storage service plan: $FILES_SERVICE_PLAN"
else
  echo "Drupal application file storage service plan (override with -l|--files-plan): $FILES_SERVICE_PLAN"
fi

#-------------------------------------------------------------------------------
# Begin

# Prepare application (build a fresh copy)
cd "$TOP_DIR"

# Push application to cloud.gov 
# (but do not start it until we create and attach the services)
cf push --no-start

# Create a database service and attach to application
APP_DB_NAME="$APP_NAME-db"

cf create-service "$DB_SERVICE_NAME" "$DB_SERVICE_PLAN" "$APP_DB_NAME"
cf bind-service "$APP_NAME" "$APP_DB_NAME"

# Create a file storage container and attach to application
APP_FILES_NAME="$APP_NAME-files"

cf create-service "$FILES_SERVICE_NAME" "$FILES_SERVICE_PLAN" "$APP_FILES_NAME"
cf bind-service "$APP_NAME" "$APP_FILES_NAME"

if [ "$APP_START" == "start" ]; then
  # Start application
  cf start "$APP_NAME"
fi

echo "Successfully initialized $APP_NAME application"
