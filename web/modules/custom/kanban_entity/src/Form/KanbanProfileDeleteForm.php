<?php
/**
 * @file
 * Contains \Drupal\kanban_entity\Form\KanbanProfileDeleteForm.
 */

namespace Drupal\kanban_entity\Form;

use Drupal\Core\Entity\EntityDeleteForm;
use Drupal\Core\Url;

/**
 * Form that handles the removal of Kanban board entities.
 */
class KanbanProfileDeleteForm extends EntityDeleteForm {

  /**
   * {@inheritdoc}
   */
  public function getCancelUrl() {
    return new Url('entity.kanban_profile.list_form');
  }
}