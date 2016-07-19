<?php
/**
 * @file
 * Contains \Drupal\kanban_entity\Form\KanbanDisplayForm
 */

namespace Drupal\kanban_entity\Form;

use Drupal\Component\Utility\Html;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a Display Form to be used to update a Kanban board content.
 */
class KanbanDisplayForm extends FormBase {

  /*************************************************************************
   *
   * Implementation of interface FormInterface.
   *
   */

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return Html::getUniqueId('kanban-display-form');
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $form = array();

    $form['actions']['#type'] = 'actions';
    $form['actions']['submit'] = array(
      '#type' => 'submit',
      '#value' => $this->t('Update'),
      '#button_type' => 'primary',
    );

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    dpm('validating');
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    drupal_set_message($this->t('Your form has been submitted'));
    dpm('submitting');
  }

}
