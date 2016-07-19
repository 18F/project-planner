<?php

namespace Drupal\kanban_entity\Form;

use Drupal\Core\Entity\ContentEntityForm;
use Drupal\Core\Form\FormStateInterface;

/**
 * Form controller for Kanban board data collection edit forms.
 *
 * @ingroup kanban_entity
 */
class KanbanBoardForm extends ContentEntityForm {

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    /* @var $entity \Drupal\kanban_entity\Entity\KanbanBoard */
    $form = parent::buildForm($form, $form_state);
    $entity = $this->entity;

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {
    $entity = $this->entity;
    $status = parent::save($form, $form_state);

    switch ($status) {
      case SAVED_NEW:
        drupal_set_message($this->t('Created the %label Kanban board.', array(
          '%label' => $entity->label(),
        )));
        break;

      default:
        drupal_set_message($this->t('Saved the %label Kanban board.', array(
          '%label' => $entity->label(),
        )));
    }
    $form_state->setRedirect('entity.kanban_board.canonical', array('kanban_board' => $entity->id()));
  }
}
