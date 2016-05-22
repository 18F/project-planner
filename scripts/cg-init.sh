#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

APP_DEFAULT_NAME="project-planner"
APP_NAME="$APP_DEFAULT_NAME"

APP_DEFAULT_START="start"
APP_START="$APP_DEFAULT_START"

RDS_DEFAULT_SERVICE_NAME="aws-rds"
RDS_SERVICE_NAME="$RDS_DEFAULT_SERVICE_NAME"
RDS_DEFAULT_SERVICE_PLAN="shared-mysql"
RDS_SERVICE_PLAN="$RDS_DEFAULT_SERVICE_PLAN"

S3_DEFAULT_SERVICE_NAME="s3"
S3_SERVICE_NAME="$S3_DEFAULT_SERVICE_NAME"
S3_DEFAULT_SERVICE_PLAN="basic"
S3_SERVICE_PLAN="$S3_DEFAULT_SERVICE_PLAN"

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
    -r|--rds-name)
      RDS_SERVICE_NAME="$2"
      shift
    ;;
    -p|--rds-plan)
      RDS_SERVICE_PLAN="$2"
      shift
    ;;
    -s|--s3-name)
      S3_SERVICE_NAME="$2"
      shift
    ;;
    -l|--s3-plan)
      S3_SERVICE_PLAN="$2"
      shift
    ;;
    -h|--help)
      message="
 Usage: ./cg-init.sh [ -h ]
 
   -h | --help      |  Display this help message
   -o | --no-start  |  Create the application and related services but do not start (default: $APP_START)
   -n | --name      |  Specify the name of the drupal application (default: $APP_NAME)
   -r | --rds-name  |  Specify the name of the drupal application RDS database (default: $RDS_SERVICE_NAME)
   -p | --rds-plan  |  Specify a service plan for the drupal application RDS database (default: $RDS_SERVICE_PLAN)
   -s | --s3-name   |  Specify the name of the drupal application S3 files bucket (default: $S3_SERVICE_NAME)
   -l | --s3-plan   |  Specify a service plan for the drupal application S3 files bucket (default: $S3_SERVICE_PLAN)
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

if [ "$RDS_SERVICE_NAME" != "$RDS_DEFAULT_SERVICE_NAME" ]; then
  echo "Drupal application RDS database service name: $RDS_SERVICE_NAME"
else
  echo "Drupal application RDS database service name (override with -r|--rds-name): $RDS_SERVICE_NAME"
fi

if [ "$RDS_SERVICE_PLAN" != "$RDS_DEFAULT_SERVICE_PLAN" ]; then
  echo "Drupal application RSA database service plan: $RDS_SERVICE_PLAN"
else
  echo "Drupal application RSA database service plan (override with -p|--rds-plan): $RDS_SERVICE_PLAN"
fi

if [ "$S3_SERVICE_NAME" != "$S3_DEFAULT_SERVICE_NAME" ]; then
  echo "Drupal application S3 files storage name: $S3_SERVICE_NAME"
else
  echo "Drupal application S3 files storage name (override with -s|--s3-name): $S3_SERVICE_NAME"
fi

if [ "$S3_SERVICE_PLAN" != "$S3_DEFAULT_SERVICE_PLAN" ]; then
  echo "Drupal application S3 files storage service plan: $S3_SERVICE_PLAN"
else
  echo "Drupal application S3 files storage service plan (override with -l|--s3-plan): $S3_SERVICE_PLAN"
fi

#-------------------------------------------------------------------------------
# Begin

# Push application to cloud.gov 
# (but do not start it until we create and attach the services)
cf push --no-start

# Create an RDS MySQL database service
APP_DB_NAME="$APP_NAME-db"

cf create-service "$RDS_SERVICE_NAME" "$RDS_SERVICE_PLAN" "$APP_DB_NAME"
cf bind-service "$APP_NAME" "$APP_DB_NAME"

# Create an S3 files bucket
APP_S3_NAME="$APP_NAME-s3"

cf create-service "$S3_SERVICE_NAME" "$S3_SERVICE_PLAN" "$APP_S3_NAME"
cf bind-service "$APP_NAME" "$APP_S3_NAME"

if [ "$APP_START" == "start" ]; then
  # Start application
  cf start "$APP_NAME"
fi

echo "Successfully initialized $APP_NAME application"
