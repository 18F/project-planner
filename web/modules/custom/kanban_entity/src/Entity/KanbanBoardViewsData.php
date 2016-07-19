<?php

namespace Drupal\kanban_entity\Entity;

use Drupal\views\EntityViewsData;
use Drupal\views\EntityViewsDataInterface;

/**
 * Provides Views data for Kanban board data collection entities.
 */
class KanbanBoardViewsData extends EntityViewsData implements EntityViewsDataInterface {

  /**
   * {@inheritdoc}
   */
  public function getViewsData() {
    $data = parent::getViewsData();

    $data['kanban_board']['table']['base'] = array(
      'field' => 'id',
      'title' => $this->t('Kanban board'),
      'help' => $this->t('The Kanban board ID.'),
    );

    return $data;
  }

}
