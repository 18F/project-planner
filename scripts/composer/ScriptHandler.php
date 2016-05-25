<?php

/**
 * @file
 * Contains \DrupalProject\composer\ScriptHandler.
 */

namespace DrupalProject\composer;

use Composer\Script\Event;
use Symfony\Component\Filesystem\Filesystem;

class ScriptHandler {

  protected static function getDrupalRoot($project_root) {
    return $project_root .  '/web';
  }

  public static function buildScaffold(Event $event) {
    $fs = new Filesystem();
    if (!$fs->exists(static::getDrupalRoot(getcwd()) . '/autoload.php')) {
      \DrupalComposer\DrupalScaffold\Plugin::scaffold($event);
    }
  }

  public static function createRequiredFiles(Event $event) {
    $fs = new Filesystem();
    $root = static::getDrupalRoot(getcwd());

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
    if (!$fs->exists($root . '/sites/default/files')) {
      $oldmask = umask(0);
      $fs->mkdir($root . '/sites/default/files', 0777);
      umask($oldmask);
      $event->getIO()->write("Create a sites/default/files directory with chmod 0777");
    }
  }
}
