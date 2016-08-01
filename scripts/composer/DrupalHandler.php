<?php

/**
 * @file
 * Contains \DrupalProject\composer\DrupalHandler.
 */

namespace DrupalProject\composer;

use Composer\Script\Event;

use Symfony\Component\Filesystem\Filesystem;

use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

use Symfony\Component\Yaml\Yaml;

class DrupalHandler {

  //----------------------------------------------------------------------------
  // Global properties

  protected static $site_exists = NULL;

  //----------------------------------------------------------------------------
  // Initialization methods

  /**
   * Initialize public web facing files and directories
   */
  public static function initializeFiles(Event $event) {
    $fs = new Filesystem();
    $root = static::_getDrupalRoot(getcwd());

    // Prepare the settings file for installation
    if ($fs->exists($root . '/sites/default/settings.php')) {
      $event->getIO()->write(" * Ensuring sites/default/settings.php is read only");
      $fs->chmod($root . '/sites/default/settings.php', 0444);
    }

    // Prepare the services file for installation
    if ($fs->exists($root . '/sites/default/services.yml')) {
      $event->getIO()->write(" * Ensuring sites/default/services.yml is read only");
      $fs->chmod($root . '/sites/default/services.yml', 0444);
    }

    // Initialize files directory
    if (!$fs->exists($root . '/sites/default/files')) {
      $event->getIO()->write(" * Creating a sites/default/files directory with chmod 0777");
      $oldmask = umask(0);
      $fs->mkdir($root . '/sites/default/files', 0777);
      umask($oldmask);
    }
    // Initialize CSS aggregation directory
    if (!$fs->exists($root . '/sites/default/files/css')) {
      $event->getIO()->write(" * Creating a sites/default/css directory with chmod 0777");
      $oldmask = umask(0);
      $fs->mkdir($root . '/sites/default/files/css', 0777);
      umask($oldmask);
    }
  }

  /**
   * Generate and set a fixed hash salt
   */
  public static function setHashSalt(Event $event) {
    $private = static::_getDrupalPrivate(getcwd());
    $hash_salt = static::_generateRandomString();

    if (static::_check('DRUPAL_SALT')) {
      $event->getIO()->write(" * Generating new Drupal Hash Salt");
      file_put_contents("$private/hash_salt.txt", $hash_salt);
    }
  }

  /**
   * Build theme files
   */
  public static function buildTheme(Event $event) {
    $fs = new Filesystem();
    $root = static::_getDrupalRoot(getcwd());

    if (static::_check('DRUPAL_BUILD_THEME') && !empty(static::_runCommand("which lessc", 1800, NULL, FALSE))) {
      $event->getIO()->write(" * Building Drupal theme files");
      $theme = static::_getDrupalTheme($root);
      static::_runCommand("lessc $theme/less/style.less > $theme/css/style.css");
    }
  }

  /**
   * Initialize a new Drupal site
   */
  public static function initializeSite(Event $event) {
    $fs = new Filesystem();
    $cwd = getcwd();
    $home = (getenv('HOME') === FALSE ? '/root' : getenv('HOME'));
    $vendor = static::_getDrupalVendor($cwd);
    $root = static::_getDrupalRoot($cwd);

    $db = static::_getDrupalBootstrapDB($cwd);
    $pg_pass = "${home}/.pgpass";

    if (static::_check('DRUPAL_INIT') && !static::_siteExists($vendor, $root)) {
      # Get primary database connection
      $db_conn = static::_getDrupalDBInfo();

      if (!is_null($db_conn)) {
        $event->getIO()->write(" * Bootstrapping Drupal");

        # Setup Postgres password file
        $pass_entry = $db_conn['host'] . ':' . $db_conn['port'] . ':' . $db_conn['db_name'] . ':' . $db_conn['username'] . ':' . $db_conn['password'];
        static::_runCommand("echo '$pass_entry' > '$pg_pass'");
        static::_runCommand("chmod 600 '$pg_pass'");

        # Try to install an initial Drupal site
        $event->getIO()->write(static::_runCommand(
          "psql --host=" . $db_conn['host'] .
          " --port=" . $db_conn['port'] .
          " --username=" . $db_conn['username'] .
          " --dbname=" . $db_conn['db_name'] .
          " < $db", 7200, TRUE)
        );
      }
    }
  }

  /**
   * Synchronize site configurations from project source
   */
  public static function syncConfigurations(Event $event) {
    $fs = new Filesystem();
    $cwd = getcwd();
    $config = static::_getDrupalConfig($cwd);
    $vendor = static::_getDrupalVendor($cwd);
    $root = static::_getDrupalRoot($cwd);

    if (static::_check('DRUPAL_SYNC') && static::_siteExists($vendor, $root, TRUE)) {
      # Ensuring that the config module is enabled
      $event->getIO()->write(" * Ensuring config module is enabled");
      static::_runCommand("$vendor/drush/drush/drush -y --root='$root' pm-enable 'config'", 1800, FALSE);

      # Set new site UUID to old UUID
      $event->getIO()->write(" * Synchronizing Drupal site UUIDs (config to live)");
      $site_info = Yaml::parse(file_get_contents("$config/system.site.yml"));
      $uuid = $site_info['uuid'];
      static::_runCommand("$vendor/drush/drush/drush -y --root='$root' config-set 'system.site' uuid '$uuid'", 1800, FALSE);

      # Import configurations
      $event->getIO()->write(" * Importing Drupal configurations");
      static::_runCommand("$vendor/drush/drush/drush -y --root='$root' config-import --source='$config'", 7200, TRUE);

      if (isset($_ENV['DOCKER_IMAGE'])) {
        $config_override = static::_getDrupalDockerConfig($cwd, $_ENV['DOCKER_IMAGE']);

        if ($fs->exists($config_override)) {
          static::_runCommand("$vendor/drush/drush/drush -y --root='$root' config-import --partial --source='$config_override'", 7200, TRUE);
        }
      }
      # Run any database updates
      $event->getIO()->write(" * Applying any needed database updates");
      static::_runCommand("$vendor/drush/drush/drush -y --root='$root' updatedb", 7200, TRUE);

      # Run any updates on entity fields
      $event->getIO()->write(" * Synchronizing entity definitions from configuration");
      static::_runCommand("$vendor/drush/drush/drush -y --root='$root' entity-updates", 7200, TRUE);
    }
  }

  //----------------------------------------------------------------------------
  // Helper methods

  /**
   * Check if site exists and return boolean to indicate if so
   */
  protected static function _siteExists($vendor, $root, $force = FALSE) {
    if ($force || is_null(static::$site_exists)) {
      static::$site_exists = FALSE;

      try {
        # Command to check for existence of Drupal site
        $message = static::_runCommand("$vendor/drush/drush/drush --root='$root' status", 3600, NULL);

        if (preg_match('/Drupal\sbootstrap\s+\:\s+Successful\s/i', $message)) {
          static::$site_exists = TRUE;
        }
      }
      catch (ProcessFailedException $error) {
      }
    }
    return static::$site_exists;
  }

  /**
   * Gather all Cloud Foundry services through the environment
   */
  protected static function _services() {
    $data = array();
    $vcap_services = getenv('VCAP_SERVICES');

    if ($vcap_services !== FALSE) {
      $data = json_decode($vcap_services, true);
    }
    return $data;
  }

  /**
   * Return the primary database connection information
   */
  protected static function _getDrupalDBInfo() {
    $db_services = array();

    foreach(static::_services() as $service_provider => $service_list) {
      foreach ($service_list as $service) {
        // looks for tags of 'Postgres'
        if (in_array('postgresql', $service['tags'], true)) {
          $db_services[] = $service;
          continue;
        }
      }
    }

    if (empty($db_services)) {
      return NULL;
    }
    return $db_services[0]['credentials'];
  }

  /**
   * Return the Root Drupal configuration directory
   */
  protected static function _getDrupalConfig($project_root) {
    return $project_root .  '/config';
  }

  /**
   * Return the Dockerized Drupal configuration directory
   */
  protected static function _getDrupalDockerConfig($project_root, $docker_image) {
    return $project_root . '/docker/' . $docker_image . '/config';
  }

  /**
   * Return the Root Drupal private asset directory
   */
  protected static function _getDrupalPrivate($project_root) {
    return $project_root .  '/private';
  }

  /**
   * Return the Root Drupal vendor directory
   */
  protected static function _getDrupalVendor($project_root) {
    return $project_root .  '/vendor';
  }

  /**
   * Return the Root Drupal web directory
   */
  protected static function _getDrupalRoot($project_root) {
    return $project_root .  '/web';
  }

  /**
   * Return the Root Drupal theme directory
   */
  protected static function _getDrupalTheme($drupal_root) {
    $theme_name = (getenv('DRUPAL_THEME') !== FALSE ? trim(getenv('DRUPAL_THEME')) : 'bootstrap_18f');
    return $drupal_root .  '/themes/custom/' . $theme_name;
  }

  /**
   * Return the Root Drupal configuration directory
   */
  protected static function _getDrupalBootstrapDB($project_root) {
    $db_name = (getenv('DRUPAL_DB') !== FALSE ? trim(getenv('DRUPAL_DB')) : 'bootstrap');
    return $project_root .  '/db/' . preg_replace('/\.sql$/i', '', $db_name) . '.sql';
  }

  /**
   * Run a command as a process on the local system
   */
  protected static function _runCommand($command, $timeout = 3600, $follow = TRUE, $abort = TRUE) {
    $process = new Process($command);
    $process->setTimeout($timeout);
    $process->setIdleTimeout($timeout);

    $process->run(function ($type, $buffer) use (&$follow) {
      if ($type === Process::ERR) {
        if (!is_null($follow)) {
          echo '  - ' . $buffer;
        }
      } else {
        if ($follow) {
          echo '  - ' . $buffer;
        }
      }
    });

    // executes after the command finishes
    if ($abort && !$process->isSuccessful()) {
      throw new ProcessFailedException($process);
    }

    return $process->getOutput();
  }

  /**
   * Generate a imperfect somewhat randomistic string of a specified length
   */
  protected static function _generateRandomString($length = 100) {
    return substr(str_repeat(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), ceil($length / 60)), 0, $length);
  }

  /**
   * Check an environment variable and return corresponding boolean value
   */
  protected static function _check($variable, $default = TRUE) {
    $check = FALSE;
    $value = getenv($variable);

    if ($value === FALSE) {
      $check = $default;
    } elseif (strlen($value) > 0) {
      if (preg_match('/^\s*(true|yes|1)\s*$/i', $value)) {
        $check = TRUE;
      }
    }
    return $check;
  }
}
