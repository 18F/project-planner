<?php

namespace Drupal\kanban_entity\Entity;

use Drupal\Core\Entity\EntityStorageInterface;
use Drupal\Core\Field\BaseFieldDefinition;
use Drupal\Core\Entity\ContentEntityBase;
use Drupal\Core\Entity\EntityChangedTrait;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\user\UserInterface;

/**
 * Defines the Kanban board entity.
 *
 * @ingroup kanban_entity
 *
 * @ContentEntityType(
 *   id = "kanban_board",
 *   label = @Translation("Kanban board"),
 *   base_table = "kanban_board",
 *   admin_permission = "administer kanban",
 *   handlers = {
 *     "view_builder" = "Drupal\Core\Entity\EntityViewBuilder",
 *     "list_builder" = "Drupal\kanban_entity\Controller\KanbanBoardListBuilder",
 *     "views_data" = "Drupal\kanban_entity\Entity\KanbanBoardViewsData",
 *     "form" = {
 *       "default" = "Drupal\kanban_entity\Form\KanbanBoardForm",
 *       "add" = "Drupal\kanban_entity\Form\KanbanBoardForm",
 *       "edit" = "Drupal\kanban_entity\Form\KanbanBoardForm",
 *       "delete" = "Drupal\kanban_entity\Form\KanbanBoardDeleteForm",
 *     },
 *     "access" = "Drupal\kanban_entity\Entity\KanbanBoardAccessControlHandler",
 *     "route_provider" = {
 *       "html" = "Drupal\kanban_entity\Entity\KanbanBoardHtmlRouteProvider",
 *     },
 *   },
 *   entity_keys = {
 *     "id" = "id",
 *     "uuid" = "uuid",
 *     "uid" = "user_id",
 *   },
 *   links = {
 *     "delete-form" = "/admin/reports/kanban/{kanban_board}/delete",
 *     "canonical" = "/admin/reports/kanban/{kanban_board}",
 *     "collection" = "/admin/reports/kanban",
 *   },
 *   field_ui_base_route = "entity.kanban_board.settings"
 * )
 */
class KanbanBoard extends ContentEntityBase implements KanbanBoardInterface {

  /**
   * {@inheritdoc}
   */
  public static function preCreate(EntityStorageInterface $storage_controller, array &$values) {
    parent::preCreate($storage_controller, $values);
    $values += array(
      'user_id' => \Drupal::currentUser()->id(),
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getOwner() {
    return $this->get('user_id')->entity;
  }

  /**
   * {@inheritdoc}
   */
  public function getOwnerId() {
    return $this->get('user_id')->target_id;
  }

  /**
   * {@inheritdoc}
   */
  public function setOwnerId($uid) {
    $this->set('user_id', $uid);
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function setOwner(UserInterface $account) {
    $this->set('user_id', $account->id());
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function getBlock() {
    return $this->get('block')->value;
  }

  /**
   * {@inheritdoc}
   */
  public function setBlock($block_uuid) {
    $this->set('block', $block_uuid);
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function getProfile() {
    return $this->get('profile')->value;
  }

  /**
   * {@inheritdoc}
   */
  public function setProfile($profile_id) {
    $this->set('profile', $profile_id);
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public static function baseFieldDefinitions(EntityTypeInterface $entity_type) {
    $fields = parent::baseFieldDefinitions($entity_type);

    $fields['user_id'] = BaseFieldDefinition::create('entity_reference')
      ->setLabel(t('Authored by'))
      ->setDescription(t('The user ID of author of the Kanban board.'))
      ->setRevisionable(TRUE)
      ->setSetting('target_type', 'user')
      ->setSetting('handler', 'default')
      ->setDefaultValueCallback('Drupal\node\Entity\Node::getCurrentUserId')
      ->setTranslatable(TRUE)
      ->setDisplayOptions('view', array(
        'label' => 'hidden',
        'type' => 'author',
        'weight' => 0,
      ))
      ->setDisplayConfigurable('form', FALSE)
      ->setDisplayConfigurable('view', TRUE);

    $fields['block'] = BaseFieldDefinition::create('string')
      ->setLabel(t('Parent Kanban block UUID'))
      ->setDescription(t('The system UUID of the parent Kanban block.'))
      ->setSettings(array(
        'max_length' => 100,
        'text_processing' => 0,
      ))
      ->setDefaultValue('')
      ->setDisplayOptions('view', array(
        'label' => 'above',
        'type' => 'string',
        'weight' => -4,
      ))
      ->setDisplayConfigurable('form', FALSE)
      ->setDisplayConfigurable('view', TRUE);

    $fields['profile'] = BaseFieldDefinition::create('string')
      ->setLabel(t('Parent Kanban profile'))
      ->setDescription(t('The system Id of the parent Kanban profile.'))
      ->setSettings(array(
        'max_length' => 100,
        'text_processing' => 0,
      ))
      ->setDefaultValue('')
      ->setDisplayOptions('view', array(
        'label' => 'above',
        'type' => 'string',
        'weight' => -4,
      ))
      ->setDisplayConfigurable('form', FALSE)
      ->setDisplayConfigurable('view', TRUE);

    return $fields;
  }
}
