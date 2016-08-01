<?php

require_once "web/autoload.php";

use Symfony\Component\Yaml\Yaml;

$config_base = $argv[1]; // docker-compose
$variable_base = $argv[2]; // docker-variables
$variable_environment = (count($argv) < 3 || empty($argv[3])) ? $variable_base : "${variable_base}.${argv[3]}"; // production

$public_config = Yaml::parse(file_get_contents("${config_base}.public.yml"));
$variables = Yaml::parse(file_get_contents("${variable_environment}.default.yml"));

if (file_exists("${variable_environment}.yml")) {
  $variables_overrides = Yaml::parse(file_get_contents("${variable_environment}.yml"));
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
file_put_contents("${config_base}.yml", Yaml::dump($config, 5, 2));
