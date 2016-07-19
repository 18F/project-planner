<?php

/**
 * @file
 * Contains kanban_board.page.inc.
 *
 * Page callback for Kanban board entities.
 */

use Drupal\Core\Render\Element;
use Drupal\Core\Link;
use Drupal\Core\Url;

/**
 * Prepares variables for Kanban board templates.
 *
 * Default template: kanban_board.html.twig.
 *
 * @param array $variables
 *   An associative array containing:
 *   - elements: An associative array containing the user information and any
 *   - attributes: HTML attributes for the containing element.
 */
function template_preprocess_kanban_board(array &$variables) {
  // Fetch KanbanBoard Entity Object.
  $kanban_board = $variables['elements']['#kanban_board'];

  // Helpful $content variable for templates.
  foreach (Element::children($variables['elements']) as $key) {
    $variables['content'][$key] = $variables['elements'][$key];
  }
}
