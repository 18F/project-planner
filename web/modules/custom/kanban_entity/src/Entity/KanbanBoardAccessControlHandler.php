<?php

namespace Drupal\kanban_entity\Entity;

use Drupal\Core\Entity\EntityAccessControlHandler;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Session\AccountInterface;
use Drupal\Core\Access\AccessResult;

/**
 * Access controller for the Kanban board data collection entity.
 *
 * @see \Drupal\kanban_entity\Entity\KanbanBoard.
 */
class KanbanBoardAccessControlHandler extends EntityAccessControlHandler {

  /**
   * {@inheritdoc}
   */
  protected function checkAccess(EntityInterface $entity, $operation, AccountInterface $account) {
    /** @var \Drupal\kanban_entity\Entity\KanbanBoardInterface $entity */
    switch ($operation) {
      case 'view':
        return AccessResult::allowedIfHasPermission($account, 'view kanban boards');

      case 'update':
        return AccessResult::allowedIfHasPermission($account, 'administer kanban');

      case 'delete':
        return AccessResult::allowedIfHasPermission($account, 'administer kanban');
    }

    // Unknown operation, deny.
    return AccessResult::forbidden();
  }

  /**
   * {@inheritdoc}
   */
  protected function checkCreateAccess(AccountInterface $account, array $context, $entity_bundle = NULL) {
    return AccessResult::forbidden();
  }

}
