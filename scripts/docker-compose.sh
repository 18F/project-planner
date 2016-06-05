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

php -r '
require_once "web/autoload.php";
  
use Symfony\Component\Yaml\Yaml;

$public_config = Yaml::parse(file_get_contents("docker-compose.public.yml"));
$variables = Yaml::parse(file_get_contents("docker-variables.default.yml"));

if (file_exists("docker-variables.yml")) {
  $variables_overrides = Yaml::parse(file_get_contents("docker-variables.yml"));
  $variables = array_merge($variables, $variables_overrides);  
}

# Recursive interpolation goodness

function interpolate($config, $variables) {
  foreach ($config as $name => $data) {
    switch (gettype($data)) {
      case "array":
        $config[$name] = interpolate($data, $variables);
        break;
      case "string":
        foreach ($variables as $key => $value) {
          $data = str_replace("{{{$key}}}", $value, $data);
        }
        $config[$name] = $data;
        break;
      default:
        # We only care about arrays and strings
    }
  }
  return $config;
}

#---

$config = interpolate($public_config, $variables);
file_put_contents("docker-compose.yml", Yaml::dump($config, 5, 2));
'
echo "Successfully generated the Docker Compose configuration file: docker-compose.yml"
