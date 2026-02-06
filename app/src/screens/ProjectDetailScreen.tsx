import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  TextInput,
  Modal,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRoute, useNavigation } from '@react-navigation/native';
import { colors, spacing, sizing, typography } from '../theme';
import { useProjects } from '../context/ProjectContext';
import { demoItems, rarityColors, rarityLabels } from '../data/items';
import type { LibraryItem } from '../data/items';

interface Category {
  id: string;
  name: string;
  emoji: string;
  description: string;
}

const categories: Category[] = [
  { id: 'weapons', name: 'Waffen', emoji: '⚔️', description: 'Schwerter, Äxte, Bögen' },
  { id: 'armor', name: 'Rüstung', emoji: '🛡️', description: 'Helme, Brustpanzer, Hosen' },
  { id: 'mobs', name: 'Mobs', emoji: '👾', description: 'Tiere, Monster, NPCs' },
  { id: 'food', name: 'Nahrung', emoji: '🍖', description: 'Essen, Tränke' },
  { id: 'blocks', name: 'Blöcke', emoji: '🧱', description: 'Baublöcke, Dekorationen' },
  { id: 'tools', name: 'Werkzeuge', emoji: '🔨', description: 'Spitzhacken, Schaufeln' },
];

export default function ProjectDetailScreen() {
  const route = useRoute();
  const navigation = useNavigation<any>();
  const { projectId } = route.params as { projectId: string };
  const { getProject, removeItemFromProject } = useProjects();
  const project = getProject(projectId);

  const [showItemModal, setShowItemModal] = useState(false);
  const [modalMode, setModalMode] = useState<'category' | 'item'>('category');
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(null);
  const [searchQuery, setSearchQuery] = useState('');

  if (!project) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyEmoji}>❌</Text>
          <Text style={styles.emptyText}>Projekt nicht gefunden</Text>
        </View>
      </SafeAreaView>
    );
  }

  const filteredModalItems = demoItems.filter(item => {
    const matchesCategory = item.category === selectedCategory?.id;
    const matchesSearch = item.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  const handleAddItem = () => {
    setModalMode('category');
    setSelectedCategory(null);
    setSearchQuery('');
    setShowItemModal(true);
  };

  const handleCategorySelect = (category: Category) => {
    setSelectedCategory(category);
    setModalMode('item');
  };

  const handleBackToCategories = () => {
    setModalMode('category');
    setSelectedCategory(null);
    setSearchQuery('');
  };

  const handleItemSelect = (item: LibraryItem) => {
    setShowItemModal(false);
    navigation.getParent()?.navigate('Workshop', {
      selectedItem: {
        name: item.name,
        emoji: item.emoji,
        stat: item.stat,
        rarity: item.rarity,
        category: item.category,
      },
      projectId: project.id,
    });
  };

  const handleDeleteItem = (itemId: string) => {
    removeItemFromProject(projectId, itemId);
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity
          style={styles.backBtn}
          onPress={() => navigation.goBack()}
          hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
        >
          <Text style={styles.backIcon}>←</Text>
        </TouchableOpacity>
        <View style={styles.titleContainer}>
          <Text style={styles.titleEmoji}>{project.emoji}</Text>
          <Text style={styles.title} numberOfLines={1}>{project.name}</Text>
        </View>
        <View style={{ width: sizing.touchMinimum }} />
      </View>

      {/* Content */}
      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* Item Count */}
        <Text style={styles.sectionTitle}>
          📦 Items ({project.items.length})
        </Text>

        {/* Item List */}
        {project.items.length === 0 ? (
          <View style={styles.emptyState}>
            <Text style={styles.emptyStateEmoji}>📭</Text>
            <Text style={styles.emptyStateTitle}>Noch keine Items</Text>
            <Text style={styles.emptyStateSubtitle}>
              Füge dein erstes Item hinzu!
            </Text>
          </View>
        ) : (
          project.items.map((item) => (
            <View key={item.id} style={styles.itemRowWrapper}>
              <View style={styles.itemRow}>
                <View style={styles.itemIconContainer}>
                  <Text style={styles.itemEmoji}>{item.emoji}</Text>
                </View>
                <View style={styles.itemInfo}>
                  <Text style={styles.itemName}>{item.name}</Text>
                  <Text style={styles.itemStat}>{item.stat}</Text>
                </View>
                <View style={[
                  styles.itemRarityBadge,
                  { backgroundColor: rarityColors[item.rarity as keyof typeof rarityColors] || colors.rarity.common }
                ]}>
                  <Text style={styles.itemRarityText}>
                    {rarityLabels[item.rarity as keyof typeof rarityLabels] || item.rarity}
                  </Text>
                </View>
              </View>
              <TouchableOpacity
                style={styles.deleteItemBtn}
                onPress={() => handleDeleteItem(item.id)}
                activeOpacity={0.7}
                hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
              >
                <Text style={styles.deleteItemBtnText}>🗑️</Text>
              </TouchableOpacity>
            </View>
          ))
        )}

        {/* Bottom Padding */}
        <View style={{ height: 100 }} />
      </ScrollView>

      {/* Add Item Button (fixed at bottom) */}
      <View style={styles.addBtnContainer}>
        <TouchableOpacity
          style={styles.addBtn}
          onPress={handleAddItem}
          activeOpacity={0.8}
        >
          <Text style={styles.addBtnEmoji}>➕</Text>
          <Text style={styles.addBtnText}>Item hinzufügen</Text>
        </TouchableOpacity>
      </View>

      {/* Item Selection Modal */}
      <Modal
        visible={showItemModal}
        animationType="slide"
        transparent={false}
        onRequestClose={() => setShowItemModal(false)}
      >
        <SafeAreaView style={styles.modalContainer}>
          {/* Modal Header */}
          <View style={styles.modalHeader}>
            <TouchableOpacity
              style={styles.modalCloseBtn}
              onPress={() => {
                if (modalMode === 'item') {
                  handleBackToCategories();
                } else {
                  setShowItemModal(false);
                }
              }}
              hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
            >
              <Text style={styles.modalCloseBtnText}>←</Text>
            </TouchableOpacity>
            <Text style={styles.modalTitle}>
              {modalMode === 'category'
                ? '🎯 Kategorie auswählen'
                : `${selectedCategory?.emoji} ${selectedCategory?.name} auswählen`
              }
            </Text>
            <View style={{ width: sizing.touchMinimum }} />
          </View>

          {/* Search Bar (only in item mode) */}
          {modalMode === 'item' && (
            <View style={styles.modalSearchContainer}>
              <View style={styles.modalSearchBar}>
                <Text style={styles.modalSearchIcon}>🔍</Text>
                <TextInput
                  style={styles.modalSearchInput}
                  placeholder="Suche Items..."
                  placeholderTextColor={colors.textMuted}
                  value={searchQuery}
                  onChangeText={setSearchQuery}
                />
              </View>
            </View>
          )}

          {/* Content */}
          <ScrollView style={styles.modalContent} showsVerticalScrollIndicator={false}>
            {modalMode === 'category' ? (
              /* Category Grid */
              <View style={styles.categoryGrid}>
                {categories.map((category) => (
                  <TouchableOpacity
                    key={category.id}
                    style={styles.categoryCard}
                    onPress={() => handleCategorySelect(category)}
                    activeOpacity={0.7}
                  >
                    <Text style={styles.categoryEmoji}>{category.emoji}</Text>
                    <Text style={styles.categoryName}>{category.name}</Text>
                    <Text style={styles.categoryDescription}>{category.description}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            ) : (
              /* Item Grid */
              <>
                <View style={styles.modalItemGrid}>
                  {filteredModalItems.map((item) => (
                    <TouchableOpacity
                      key={item.id}
                      style={styles.modalItemCard}
                      onPress={() => handleItemSelect(item)}
                      activeOpacity={0.7}
                    >
                      <View style={styles.modalItemPreview}>
                        <Text style={styles.modalItemEmoji}>{item.emoji}</Text>
                        <View style={[styles.modalRarityBadge, { backgroundColor: rarityColors[item.rarity] }]}>
                          <Text style={styles.modalRarityText}>{rarityLabels[item.rarity]}</Text>
                        </View>
                      </View>
                      <View style={styles.modalItemInfo}>
                        <Text style={styles.modalItemName} numberOfLines={1}>{item.name}</Text>
                        <Text style={styles.modalItemStat}>{item.stat}</Text>
                      </View>
                    </TouchableOpacity>
                  ))}
                </View>

                {filteredModalItems.length === 0 && (
                  <View style={styles.modalEmpty}>
                    <Text style={styles.modalEmptyEmoji}>🔍</Text>
                    <Text style={styles.modalEmptyText}>Keine Items gefunden</Text>
                  </View>
                )}
              </>
            )}

            <View style={{ height: spacing.xxl }} />
          </ScrollView>
        </SafeAreaView>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.lg,
    backgroundColor: colors.surface,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  backBtn: {
    width: sizing.touchMinimum,
    height: sizing.touchMinimum,
    justifyContent: 'center',
    alignItems: 'center',
  },
  backIcon: {
    fontSize: 28,
    color: colors.text,
  },
  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    flex: 1,
    justifyContent: 'center',
  },
  titleEmoji: {
    fontSize: 24,
  },
  title: {
    fontSize: typography.xl,
    fontWeight: typography.bold,
    color: colors.text,
    maxWidth: 200,
  },
  content: {
    flex: 1,
    padding: spacing.xl,
  },
  sectionTitle: {
    fontSize: typography.md,
    color: colors.textSecondary,
    marginBottom: spacing.lg,
  },

  // Empty State
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  emptyState: {
    alignItems: 'center',
    paddingVertical: spacing.xxxl,
  },
  emptyStateEmoji: {
    fontSize: 64,
    marginBottom: spacing.md,
  },
  emptyStateTitle: {
    fontSize: typography.lg,
    fontWeight: typography.semibold,
    color: colors.text,
    marginBottom: spacing.sm,
  },
  emptyStateSubtitle: {
    fontSize: typography.md,
    color: colors.textMuted,
  },
  emptyEmoji: {
    fontSize: 48,
    marginBottom: spacing.md,
  },
  emptyText: {
    fontSize: typography.lg,
    color: colors.textMuted,
  },

  // Item List
  itemRowWrapper: {
    position: 'relative',
    marginBottom: spacing.md,
  },
  itemRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  itemIconContainer: {
    width: sizing.touchIdeal,
    height: sizing.touchIdeal,
    backgroundColor: colors.surfaceLight,
    borderRadius: sizing.radiusMedium,
    justifyContent: 'center',
    alignItems: 'center',
  },
  itemEmoji: {
    fontSize: 32,
  },
  itemInfo: {
    flex: 1,
  },
  itemName: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
    marginBottom: spacing.xs,
  },
  itemStat: {
    fontSize: typography.sm,
    color: colors.textSecondary,
  },
  itemRarityBadge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: 6,
  },
  itemRarityText: {
    fontSize: 10,
    fontWeight: typography.bold,
    color: colors.text,
    textTransform: 'uppercase',
  },
  deleteItemBtn: {
    position: 'absolute',
    top: spacing.sm,
    right: spacing.sm,
    width: 36,
    height: 36,
    backgroundColor: colors.error,
    borderRadius: 18,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
  },
  deleteItemBtnText: {
    fontSize: 18,
  },

  // Add Button
  addBtnContainer: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: spacing.xl,
    backgroundColor: colors.background,
    borderTopWidth: 1,
    borderTopColor: colors.border,
  },
  addBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.md,
    backgroundColor: colors.success,
    paddingVertical: spacing.lg,
    borderRadius: sizing.radiusLarge,
    minHeight: 60,
    shadowColor: colors.success,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 15,
    elevation: 8,
  },
  addBtnEmoji: {
    fontSize: 24,
  },
  addBtnText: {
    fontSize: typography.lg,
    fontWeight: typography.bold,
    color: colors.text,
  },

  // Modal Styles
  modalContainer: {
    flex: 1,
    backgroundColor: colors.background,
  },
  categoryGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.md,
    paddingTop: spacing.lg,
  },
  categoryCard: {
    width: '48%',
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    alignItems: 'center',
    minHeight: 140,
    justifyContent: 'center',
  },
  categoryEmoji: {
    fontSize: 48,
    marginBottom: spacing.sm,
  },
  categoryName: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
    marginBottom: spacing.xs,
  },
  categoryDescription: {
    fontSize: typography.xs,
    color: colors.textSecondary,
    textAlign: 'center',
  },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.lg,
    backgroundColor: colors.surface,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  modalCloseBtn: {
    width: sizing.touchMinimum,
    height: sizing.touchMinimum,
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalCloseBtnText: {
    fontSize: 28,
    color: colors.text,
  },
  modalTitle: {
    fontSize: typography.lg,
    fontWeight: typography.bold,
    color: colors.text,
  },
  modalSearchContainer: {
    backgroundColor: colors.surface,
    paddingHorizontal: spacing.xl,
    paddingBottom: spacing.lg,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  modalSearchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surfaceLight,
    borderRadius: sizing.radiusMedium,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    gap: spacing.md,
  },
  modalSearchIcon: {
    fontSize: 18,
  },
  modalSearchInput: {
    flex: 1,
    fontSize: typography.md,
    color: colors.text,
  },
  modalContent: {
    flex: 1,
    paddingHorizontal: spacing.xl,
    paddingTop: spacing.lg,
  },
  modalItemGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.md,
  },
  modalItemCard: {
    width: '48%',
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    overflow: 'hidden',
  },
  modalItemPreview: {
    height: 120,
    backgroundColor: colors.surfaceLight,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  modalItemEmoji: {
    fontSize: 56,
  },
  modalRarityBadge: {
    position: 'absolute',
    top: spacing.sm,
    right: spacing.sm,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: 6,
  },
  modalRarityText: {
    fontSize: 10,
    fontWeight: typography.bold,
    color: colors.text,
    textTransform: 'uppercase',
  },
  modalItemInfo: {
    padding: spacing.md,
  },
  modalItemName: {
    fontSize: typography.sm,
    fontWeight: typography.semibold,
    color: colors.text,
    marginBottom: spacing.xs,
  },
  modalItemStat: {
    fontSize: typography.xs,
    color: colors.textSecondary,
  },
  modalEmpty: {
    alignItems: 'center',
    paddingVertical: spacing.xxxl,
  },
  modalEmptyEmoji: {
    fontSize: 48,
    marginBottom: spacing.md,
  },
  modalEmptyText: {
    fontSize: typography.md,
    color: colors.textMuted,
  },
});
