<?php

namespace Drupal\kanban_entity\Entity;

use Drupal\Core\Entity\ContentEntityInterface;

/**
 * Provides an interface for defining Kanban board entities.
 *
 * @ingroup kanban_entity
 */
interface KanbanBoardInterface extends ContentEntityInterface {

  /**
   * Gets the parent block of this Kanban board.
   *
   * @return string
   *   String Id of the parent Kanban block.
   */
  public function getBlock();

  /**
   * Sets the parent block of this Kanban board.
   *
   * @param string $profile_id
   *   String Id of the parent Kanban block.
   *
   * @return \Drupal\kanban_entity\Entity\KanbanBoardInterface
   *   The called Kanban board entity.
   */
  public function setBlock($block_uuid);

  /**
   * Gets the parent profile of this Kanban board.
   *
   * @return string
   *   String Id of the parent Kanban configuration entity.
   */
  public function getProfile();

  /**
   * Sets the parent profile of this Kanban board.
   *
   * @param string $profile_id
   *   String Id of the parent Kanban configuration entity.
   *
   * @return \Drupal\kanban_entity\Entity\KanbanBoardInterface
   *   The called Kanban board entity.
   */
  public function setProfile($profile_id);

}
