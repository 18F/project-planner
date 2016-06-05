#!/bin/bash
#
# This script must be at the top level of the code folder structure due to
# Docker security model that prevents us from accessing files outside of the
# Docker execution directory.
#
# By having this file here we can use scripts from the "scripts" directory
# inside our Dockerfile and have them cleanly separated if there are multiple.
#

set -e

#-------------------------------------------------------------------------------
# Default properties

TOP_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"

#-------------------------------------------------------------------------------
# Property initialization

while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -h|--help)
      message="
  Usage: ./docker-build.sh [ -h ] {{required project name}}
  
   The project name is the directory name located under the docker folder
   at the root of this project.
   
   The build process needs to happen at the root of the project so we can
   use build scripts located in the scripts directory within our Dockerfile.
   This has to do with Docker security model when executing Dockerfiles.
 
   -h | --help       |  Display this help message
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

PROJECT_NAME="$key"

#---

if [ "$PROJECT_NAME" = "" ]; then
  echo "Project name required (directory name within top level docker folder)"
  exit 1
fi

#-------------------------------------------------------------------------------
# Begin

# Build Docker image
cd "$TOP_DIR"
docker build -t "$PROJECT_NAME" -f "docker/$PROJECT_NAME/Dockerfile" .
