#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

APP_DEFAULT_NAME="project-planner"
APP_NAME="$APP_DEFAULT_NAME"

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
    -h|--help)
      message="
 Usage: ./cg-destroy.sh [ -h ]
 
   -h | --help      |  Display this help message
   -n | --name      |  Specify the name of the drupal application (default: $APP_NAME)
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

#-------------------------------------------------------------------------------
# Begin

OK_PROMPT="
Executing this command will destroy your site on cloud.gov, as well as attached
databases and s3 files.  If you care about these files or databases they should be 
backed up before proceeding.

Are you absolutely sure you want to destroy $APP_NAME and all related services?
(yes|enter for no) "

read -r -p "$OK_PROMPT" response

if [[ $response =~ ^([yY][eE][sS])$ ]]; then
  # Stop application on cloud.gov 
  # (but do not destroy it until we detach and remove the services)
  cf stop "$APP_NAME"

  # Remove the RDS MySQL database service
  APP_DB_NAME="$APP_NAME-db"

  cf unbind-service "$APP_NAME" "$APP_DB_NAME"
  cf delete-service "$APP_DB_NAME" -f

  # Remove the S3 files bucket
  APP_S3_NAME="$APP_NAME-s3"

  cf unbind-service "$APP_NAME" "$APP_S3_NAME"
  cf delete-service "$APP_S3_NAME" -f

  # Remove application
  cf delete "$APP_NAME" -f -r

  echo "Successfully destroyed $APP_NAME application"
else
  echo "Aborting the destroy of the $APP_NAME application"  
fi
