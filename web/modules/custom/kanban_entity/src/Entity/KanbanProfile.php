<?php
/**
 * @file
 * Contains \Drupal\kanban_entity\Entity\KanbanProfile.
 */

namespace Drupal\kanban_entity\Entity;

use Drupal\Core\Config\Entity\ConfigEntityBase;
use Drupal\Core\Config\Entity\ConfigEntityInterface;
use Drupal\kanban_entity\KanbanInterface;

/**
 * Defines a Kanban profile configuration entity class.
 *
 * @ConfigEntityType(
 *   id = "kanban_profile",
 *   label = @Translation("Kanban profile"),
 *   module = "kanban_entity",
 *   config_prefix = "kanban_profile",
 *   admin_permission = "administer kanban",
 *   handlers = {
 *     "list_builder" = "Drupal\kanban_entity\Controller\KanbanProfileListBuilder",
 *     "form" = {
 *       "add" = "Drupal\kanban_entity\Form\KanbanProfileForm",
 *       "edit" = "Drupal\kanban_entity\Form\KanbanProfileForm",
 *       "delete" = "Drupal\kanban_entity\Form\KanbanProfileDeleteForm"
 *     }
 *   },
 *   entity_keys = {
 *     "id" = "id",
 *     "label" = "label",
 *     "weight" = "weight"
 *   },
 *   config_export = {
 *     "id",
 *     "label",
 *     "weight",
 *     "workflow",
 *     "views",
 *   },
 *   links = {
 *     "edit-form" = "/admin/structure/kanban/{kanban_profile}/edit",
 *     "delete-form" = "/admin/structure/kanban/{kanban_profile}/delete"
 *   }
 * )
 */
class KanbanProfile extends ConfigEntityBase implements KanbanProfileInterface {
  /**
   * The ID of the Kanban profile.
   *
   * @var string
   */
  public $id;

  /**
   * The Kanban profile name.
   *
   * @var string
   */
  public $label;

  /**
   * The Kanban profile weight.
   *
   * @var integer
   */
  public $weight;

  /**
   * The Kanban profile workflow.
   *
   * @var string
   */
  public $workflow;
}