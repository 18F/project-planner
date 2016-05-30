<?php

/**
 * @file
 * Contains \DrupalProject\composer\Hooks.
 */

namespace DrupalProject\composer;

use Composer\Script\Event;
use Symfony\Component\Filesystem\Filesystem;

use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class Hooks {

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

    // Create the files directory with chmod 0777
    $fs->chmod($root . '/sites/default/files', 0777);
  }

  /**
   * Do something awesome
   */
  public static function syncConfigurations(Event $event) {
    $fs = new Filesystem();
    $cwd = getcwd();
    $config = static::_getDrupalConfig($cwd);
    $vendor = static::_getDrupalVendor($cwd);
    $root = static::_getDrupalRoot($cwd);

    try {
      echo static::_runCommand("$vendor/drush/drush/drush -y -v --root='$root' config-import --source='$config'");
    }
    catch (ProcessFailedException $error) {
      if (!preg_match('/Drupal\:\:\$container is not initialized yet/', $error->getMessage())) {
        throw $error;
      }
      else {
        echo " >> No active Drupal installation\n";
      }
    }
  }

  //----------------------------------------------------------------------------
  // Helper methods

  /**
   * Return the Rood Drupal configuration directory
   */
  protected static function _getDrupalConfig($project_root) {
    return $project_root .  '/config';
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
   * Run a command as a process on the local system
   */
  public static function _runCommand($command) {
    $process = new Process($command);
    $process->run();

    // executes after the command finishes
    if (!$process->isSuccessful()) {
      throw new ProcessFailedException($process);
    }

    return $process->getOutput();
  }
}
