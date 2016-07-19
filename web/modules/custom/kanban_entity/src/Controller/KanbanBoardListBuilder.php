<?php

namespace Drupal\kanban_entity\Controller;

use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Entity\EntityListBuilder;
use Drupal\Core\Entity\Entity\EntityViewDisplay;
use Drupal\Core\Routing\LinkGeneratorTrait;
use Drupal\Core\Url;
use Drupal\page_manager\Entity\Page;

/**
 * Defines a class to build a listing of Kanban board data collection entities.
 *
 * @ingroup kanban_entity
 */
class KanbanBoardListBuilder extends EntityListBuilder {

  use LinkGeneratorTrait;

  /**
   * {@inheritdoc}
   */
  public function buildHeader() {
    $header['id'] = $this->t('Kanban board ID');
    $header['block'] = $this->t('Block');
    $header['profile'] = $this->t('Profile');
    return $header + parent::buildHeader();
  }

  /**
   * {@inheritdoc}
   */
  public function buildRow(EntityInterface $entity) {
    /* @var $entity \Drupal\kanban_entity\Entity\KanbanBoard */
    $row['id'] = $entity->id();

    if (!empty($entity->getBlock())) {
      $block = $this->loadBlock($entity->getBlock());
      $row['block'] = is_null($block) ? '<<' . $entity->getBlock() . '>>' : $entity->getBlock();
    }
    else {
      $row['block'] = '<<NONE>>';
    }

    $row['profile'] = $entity->getProfile();
    return $row + parent::buildRow($entity);
  }

  /**
   * Load a block in page manager variants if it exists
   */
  protected function loadBlock($uuid) {
    // Try page manager first
    $block = $this->loadPageManagerBlock($uuid);

    // Now try panelizer
    if (is_null($block)) {
      $block = $this->loadPanelizerBlock($uuid);
    }

    return $block;
  }

  /**
   * Load a block in page manager variants if it exists
   */
  protected function loadPageManagerBlock($uuid) {
    foreach (Page::loadMultiple() as $page) {
      $variants = $page->getVariants();

      if (!empty($variants)) {
        foreach ($variants as $name => $variant) {
          $regions = $variant->getVariantPlugin()->getRegionAssignments();

          foreach ($regions as $region => $blocks) {
            foreach ($blocks as $block_uuid => $block) {
              if ($uuid == $block_uuid) {
                return $block;
              }
            }
          }
        }
      }
    }
    return NULL;
  }

  /**
   * Load a block in panelizer entities if it exists
   */
  protected function loadPanelizerBlock($uuid) {
    $panelizer_manager = \Drupal::service('plugin.manager.panelizer_entity');

    foreach ($panelizer_manager->getDefinitions() as $entity_type_id => $panelizer_info) {
      $storage = \Drupal::entityManager()->getStorage($entity_type_id);
      $entity_ids = \Drupal::entityQuery($entity_type_id)->execute();

      foreach ($storage->loadMultiple($entity_ids) as $entity_id => $entity) {
        if ($entity->hasField('panelizer')) {
          $panelizer_info = $entity->get('panelizer')->getValue();

          foreach ($panelizer_info as $view_mode_info) {
            $panelizer_display = $view_mode_info['panels_display'];

            foreach ($view_mode_info['panels_display']['blocks'] as $block_uuid => $block) {
              if ($uuid == $block_uuid) {
                return $block;
              }
            }
          }
        }
      }
    }
    return NULL;
  }
}
