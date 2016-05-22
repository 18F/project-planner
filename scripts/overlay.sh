#!/bin/bash

set -e

#-------------------------------------------------------------------------------
# Default properties

SCRIPT_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"
TOP_DIR="$SCRIPT_DIR/.."
PUBLIC_DIR="$TOP_DIR/htdocs"

DRUPAL_BUILD_MODULES_DIR="$PUBLIC_DIR/modules/custom"
DRUPAL_CUSTOM_MODULES_DIR="$TOP_DIR/modules"

DRUPAL_BUILD_THEMES_DIR="$PUBLIC_DIR/themes/custom"
DRUPAL_CUSTOM_THEMES_DIR="$TOP_DIR/themes"

DRUPAL_BUILD_PROFILES_DIR="$PUBLIC_DIR/profiles/custom"
DRUPAL_CUSTOM_PROFILES_DIR="$TOP_DIR/profiles"

DRUPAL_BUILD_SITE_CLOUD_GOV_DIR="$PUBLIC_DIR/sites/cloud.gov"
DRUPAL_CUSTOM_SITE_CLOUD_GOV_DIR="$TOP_DIR/sites/cloud.gov"

#-------------------------------------------------------------------------------
# Property initialization

while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -h|--help)
      message="
Usage: ./overlay.sh [ -h ]

Overlay custom project code and configurations into the Composer code build.

This script is mainly used in composer post install command hook.
 
   -h | --help   |  Display this help message
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

# Copy custom modules to build directory
echo -n "Copying custom modules to $DRUPAL_BUILD_MODULES_DIR: "
rm -Rf "$DRUPAL_BUILD_MODULES_DIR"
cp -Rf "$DRUPAL_CUSTOM_MODULES_DIR" "$DRUPAL_BUILD_MODULES_DIR"
echo "done"

# Copy custom themes to build directory
echo -n "Copying custom themes to $DRUPAL_BUILD_THEMES_DIR: "
rm -Rf "$DRUPAL_BUILD_THEMES_DIR"
cp -Rf "$DRUPAL_CUSTOM_THEMES_DIR" "$DRUPAL_BUILD_THEMES_DIR"
echo "done"

# Copy custom profiles to build directory
echo -n "Copying custom profiles to $DRUPAL_BUILD_PROFILES_DIR: "
rm -Rf "$DRUPAL_BUILD_PROFILES_DIR"
cp -Rf "$DRUPAL_CUSTOM_PROFILES_DIR" "$DRUPAL_BUILD_PROFILES_DIR"
echo "done"

# Copy site settings directories to build directory
echo -n "Copying cloud.gov site configurations to $DRUPAL_BUILD_SITE_CLOUD_GOV_DIR: "
rm -Rf "$DRUPAL_BUILD_SITE_CLOUD_GOV_DIR"
cp -Rf "$DRUPAL_CUSTOM_SITE_CLOUD_GOV_DIR" "$DRUPAL_BUILD_SITE_CLOUD_GOV_DIR"
echo "done"
