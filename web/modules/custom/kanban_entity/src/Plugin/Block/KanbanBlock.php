<?php

namespace Drupal\kanban_entity\Plugin\Block;

use Drupal\Core\Entity\EntityManager;
use Drupal\Core\Plugin\ContextAwarePluginInterface;
use Drupal\Core\Block\BlockBase;
use Drupal\Core\Block\BlockPluginInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\kanban_entity\Entity\KanbanProfile;
use Drupal\kanban_entity\Entity\KanbanBoard;

/**
 * Provides a 'Kanban display' block
 *
 * @Block(
 *   id = "kanban_block",
 *   admin_label = @Translation("Kanban display")
 * )
 */
class KanbanBlock extends BlockBase implements BlockPluginInterface, ContextAwarePluginInterface {
  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    $default_config = \Drupal::config('kanban_entity.settings');

    return array(
      'profile' => $default_config->get('block.profile')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function blockForm($form, FormStateInterface $form_state) {
    $form = parent::blockForm($form, $form_state);
    $config = $this->getConfiguration();

    $profiles = KanbanProfile::loadMultiple();
    $profile_options = array();

    foreach ($profiles as $id => $profile) {
      $profile_options[$id] = $profile->label;
    }

    $form['kanban_block'] = array(
      '#type' => 'fieldset',
      '#title' => $this->t('Kanban settings'),
    );

    $form['kanban_block']['profile'] = array(
      '#type' => 'select',
      '#title' => $this->t('Select Kanban profile'),
      '#options' => $profile_options,
      '#default_value' => isset($config['profile']) ? $config['profile'] : '',
    );

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function blockSubmit($form, FormStateInterface $form_state) {
    $this->setConfigurationValue('profile', $form_state->getValue(array('kanban_block' , 'profile')));

    # Ensure entity is created
    $this->getEntity($this->getConfiguration());
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    $config = $this->getConfiguration();
    $form = array();

    dpm('$config');
    dpm($config);

    if (isset($config['profile']) && !empty($config['profile'])) {
      $form = \Drupal::formBuilder()->getForm('Drupal\kanban_entity\Form\KanbanDisplayForm');
      $profile = KanbanProfile::load($config['profile']);

      dpm('$profile');
      dpm($profile);

      $entity = $this->getEntity($config);
      dpm('entity');
      dpm($entity);

      // 1. Pull all needed data via views (view name) -> need node id and taxonomy state
      // 2. Process data into usable bucketed list based on status classification
      // 3. Render Kanban board with bucketed list

    }
    return $form;
  }

  /**
   * Construct or retrieve a kanban board entity
   */
  protected function getEntity($config) {
    $entity = \Drupal::entityManager()->loadEntityByUuid('kanban_board', $config['entity']);

    if (is_null($entity)) {
      $entity = KanbanBoard::create(array(
        'name' => $config['label'],
        'uid' => \Drupal::currentUser()->id(),
        'block' => $config['uuid'],
        'profile' => $config['profile'],
        'field_fields' => array(),
      ));

      $entity->save();
      $this->setConfigurationValue('entity', $entity->uuid());
    }
    return $entity;
  }
}