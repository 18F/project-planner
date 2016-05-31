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
  // Initialization methods

  /**
   * Build Drupal Scaffold plugin stuff
   */
  public static function buildScaffold(Event $event) {
    $fs = new Filesystem();
    if (!$fs->exists(static::_getDrupalRoot(getcwd()) . '/autoload.php')) {
      \DrupalComposer\DrupalScaffold\Plugin::scaffold($event);
    }
  }

  /**
   * Initialize public web facing files and directories
   */
  public static function initializeFiles(Event $event) {
    $fs = new Filesystem();
    $root = static::_getDrupalRoot(getcwd());

    // Prepare the settings file for installation
    if ($fs->exists($root . '/sites/default/settings.php')) {
      $fs->chmod($root . '/sites/default/settings.php', 0444);
      $event->getIO()->write("Ensure sites/default/settings.php file is read only");
    }

    // Prepare the services file for installation
    if ($fs->exists($root . '/sites/default/services.yml')) {
      $fs->chmod($root . '/sites/default/services.yml', 0444);
      $event->getIO()->write("Ensure sites/default/services.yml file is read only");
    }

    // Initialize files directory
    if (!$fs->exists($root . '/sites/default/files')) {
      $oldmask = umask(0);
      $fs->mkdir($root . '/sites/default/files', 0777);
      umask($oldmask);
      $event->getIO()->write("Create a sites/default/files directory with chmod 0777");
    }
    // Initialize CSS aggregation directory
    if (!$fs->exists($root . '/sites/default/files/css')) {
      $oldmask = umask(0);
      $fs->mkdir($root . '/sites/default/files/css', 0777);
      umask($oldmask);
      $event->getIO()->write("Create a sites/default/css directory with chmod 0777");
    }
  }

  /**
   * Generate and set a fixed hash salt
   */
  public static function setHashSalt(Event $event) {
    $fs = new Filesystem();
    $private = static::_getDrupalPrivate(getcwd());
    $hash_salt = static::_generateRandomString();

    $fs->dumpFile("$private/hash_salt.txt", $hash_salt);
  }

  /**
   * Initialize a new Drupal site
   */
  public static function initializeSite(Event $event) {
    $fs = new Filesystem();
    $cwd = getcwd();
    $vendor = static::_getDrupalVendor($cwd);
    $root = static::_getDrupalRoot($cwd);
    $db = static::_getDrupalBootstrapDB($cwd);

    try {
      # Command to check for existence of Drupal site
      static::_runCommand("$vendor/drush/drush/drush --root='$root' cache-rebuild", 3600, NULL);
    }
    catch (ProcessFailedException $error) {
      # Get MySQL database connection
      $mysql_conn = static::_getDrupalMySQL();

      if (!is_null($mysql_conn)) {
        $event->getIO()->write("Bootstrapping Drupal");

        # Try to install an initial Drupal site
        $event->getIO()->write(static::_runCommand(
          "mysql --host=" . $mysql_conn['host'] .
          " --port=" . $mysql_conn['port'] .
          " --user=" . $mysql_conn['username'] .
          " --password=" . $mysql_conn['password'] .
          " --database=" . $mysql_conn['db_name'] .
          " < $db"
        ), 7200, TRUE);
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
    $import = TRUE;

    try {
      # Command to check for existence of Drupal site
      static::_runCommand("$vendor/drush/drush/drush --root='$root' cache-rebuild", 3600, NULL);
    }
    catch (ProcessFailedException $error) {
      $import = FALSE;
    }

    if ($import) {
      $event->getIO()->write("Synchronizing Drupal configurations");

      # Set new site UUID to old UUID
      $site_info = Yaml::parse(file_get_contents("$config/system.site.yml"));
      $uuid = $site_info['uuid'];

      static::_runCommand("$vendor/drush/drush/drush -y --root='$root' config-set 'system.site' uuid '$uuid'", 1800, TRUE);

      # Import configurations
      static::_runCommand("$vendor/drush/drush/drush -y --root='$root' config-import --source='$config'", 7200, TRUE);
    }
  }

  //----------------------------------------------------------------------------
  // Helper methods

  /**
   * Gather all Cloud Foundry services through the environment
   */
  protected static function _services() {
    $data = array();

    if (isset($_ENV['VCAP_SERVICES'])) {
      $data = json_decode($_ENV['VCAP_SERVICES'], true);
    }
    return $data;
  }

  /**
   * Return the primary MySQL database connection information
   */
  protected static function _getDrupalMySQL() {
    $mysql_services = array();

    foreach(static::_services() as $service_provider => $service_list) {
      foreach ($service_list as $service) {
        // looks for tags of 'mysql'
        if (in_array('mysql', $service['tags'], true)) {
          $mysql_services[] = $service;
          continue;
        }
        // look for a service where the name includes 'mysql'
        if (strpos($service['name'], 'mysql') !== false) {
          $mysql_services[] = $service;
        }
      }
    }

    if (empty($mysql_services)) {
      return NULL;
    }
    return $mysql_services[0]['credentials'];
  }

  /**
   * Return the Rood Drupal configuration directory
   */
  protected static function _getDrupalConfig($project_root) {
    return $project_root .  '/config';
  }

  /**
   * Return the Rood Drupal private asset directory
   */
  protected static function _getDrupalPrivate($project_root) {
    return $project_root .  '/private';
  }

  /**
   * Return the Rood Drupal vendor directory
   */
  protected static function _getDrupalVendor($project_root) {
    return $project_root .  '/vendor';
  }

  /**
   * Return the Rood Drupal web directory
   */
  protected static function _getDrupalRoot($project_root) {
    return $project_root .  '/web';
  }

  /**
   * Return the Rood Drupal configuration directory
   */
  protected static function _getDrupalBootstrapDB($project_root) {
    return $project_root .  '/db/bootstrap.sql';
  }

  /**
   * Run a command as a process on the local system
   */
  protected static function _runCommand($command, $timeout = 3600, $follow = TRUE) {
    $process = new Process($command);
    $process->setTimeout($timeout);
    $process->setIdleTimeout($timeout);

    $process->run(function ($type, $buffer) use (&$follow) {
      if ($type === Process::ERR) {
        if (!is_null($follow)) {
          echo '[ERROR]> ' . $buffer;
        }
      } else {
        if ($follow) {
          echo '[OUTPUT]> ' . $buffer;
        }
      }
    });

    // executes after the command finishes
    if (!$process->isSuccessful()) {
      throw new ProcessFailedException($process);
    }

    return $process->getOutput();
  }

  /**
   * Generate a random string of a specified length
   */
  protected static function _generateRandomString($length = 100) {
    return substr(str_repeat(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), ceil($length / 60)), 0, $length);
  }
}
