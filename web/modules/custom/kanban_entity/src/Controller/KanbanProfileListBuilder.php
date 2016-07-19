<?php
/**
 * @file
 *
 * Contains Drupal\kanban_entity\Controller\KanbanProfileListBuilder
 */

namespace Drupal\kanban_entity\Controller;

use Drupal\Core\Config\Entity\DraggableListBuilder;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Form\FormStateInterface;

/**
 * Defines a class to build a listing of Kanban board entities.
 *
 * @see \Drupal\kanban_entity\Entity\KanbanEntity
 */
class KanbanProfileListBuilder extends DraggableListBuilder {
  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'kanban-profile-list-form';
  }

  /**
   * {@inheritdoc}
   */
  public function buildHeader() {
    $header['label'] = $this->t('Name');

    return $header + parent::buildHeader();
  }

  /**
   * {@inheritdoc}
   */
  public function buildRow(EntityInterface $entity) {
    $row['label'] = $this->getLabel($entity);

    return $row + parent::buildRow($entity);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    parent::submitForm($form, $form_state);
    drupal_set_message($this->t('The Kanban profile weights have been updated'));
  }

  /**
   * {@inheritdoc}
   */
  public function render() {
    $build = parent::render();

    $build['#empty'] = $this->t('There are no Kanban profiles available.');
    return $build;
  }
}