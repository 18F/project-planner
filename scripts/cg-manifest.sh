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
 Usage: ./cg-manifest.sh [ -h ] <environment>
 
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

#---

ENVIRONMENT="$key"

#-------------------------------------------------------------------------------
# Begin

cd "$TOP_DIR"

php -f "$SCRIPT_DIR/shared/interpolate.php" manifest manifest-variables "$ENVIRONMENT"
echo "Successfully generated the Cloud.gov manifest file: manifest.yml"
