<?php
/**
 * @file
 * Contains \Drupal\kanban_entity\Form\KanbanProfileForm.
 */

namespace Drupal\kanban_entity\Form;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Url;

/**
 * Class KanbanForm
 *
 * Form class for adding/editing Kanban board config entities.
 */
class KanbanProfileForm extends EntityForm {

   /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    $form = parent::form($form, $form_state);
    $kanban_profile = $this->entity;

    // Change page title for the edit operation
    if ($this->operation == 'edit') {
      $form['#title'] = $this->t('Edit Kanban profile: @name', array('@name' => $kanban_profile->label()));
    }

    $form['label'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Name'),
      '#maxlength' => 255,
      '#default_value' => $kanban_profile->label(),
      '#description' => $this->t("Kanban profile name."),
      '#required' => TRUE,
    );

    $form['id'] = array(
      '#type' => 'machine_name',
      '#maxlength' => EntityTypeInterface::BUNDLE_MAX_LENGTH,
      '#default_value' => $kanban_profile->id(),
      '#disabled' => !$kanban_profile->isNew(),
      '#machine_name' => array(
        'source' => array('label'),
        'exists' => 'kanban_profile_load'
      ),
    );

    $form['workflow'] = array(
      '#type' => 'select',
      '#title' => $this->t('Select workflow'),
      '#options' => workflow_get_workflow_names(TRUE),
      '#default_value' => $kanban_profile->workflow,
      '#ajax' => array(
        'callback' => array($this, 'workflowStateWipForm'),
        'event' => 'change',
        'progress' => array(
          'type' => 'throbber',
          'message' => t('Fetching workflow states...'),
        ),
      ),
      '#suffix' => '<span class="email-valid-message"></span>',
    );

    $form['test'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('test'),
      '#maxlength' => 255,
      '#default_value' => 'test',
      '#description' => $this->t("test."),
      '#required' => FALE,
      '#prefix' => '<div id="dropdown-second-replace">',
      '#suffix' => '</div>',
    );

    return $form;
  }

  /**
   * Workflow State WIP form
   */
  protected function workflowStateWipForm() {

  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {
    $kanban_profile = $this->entity;
    $status = $kanban_profile->save();

    if ($status) { // Success!
      drupal_set_message($this->t('Saved the Kanban profile: @label.', array(
        '@label' => $kanban_profile->label(),
      )));
    }
    else {
      drupal_set_message($this->t('The @label Kanban profile was not saved.', array(
        '@label' => $kanban_profile->label(),
      )));
    }

    $form_state->setRedirect('entity.kanban_profile.list_form');
  }
}