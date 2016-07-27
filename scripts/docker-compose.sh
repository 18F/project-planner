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
 Usage: ./docker-compose.sh [ -h ]
 
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

#-------------------------------------------------------------------------------
# Begin

# Generate completed Docker compose file (with PHP Symfony components)
cd "$TOP_DIR"

php -f "$SCRIPT_DIR/shared/interpolate.php" docker-compose docker-variables
echo "Successfully generated the Docker Compose configuration file: docker-compose.yml"
