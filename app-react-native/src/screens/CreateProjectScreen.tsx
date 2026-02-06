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
import { colors, spacing, sizing, typography } from '../theme';
import { useProjects } from '../context/ProjectContext';
import { demoItems, rarityColors, rarityLabels } from '../data/items';
import type { LibraryItem } from '../data/items';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

// ==========================================
// TYPES & CONSTANTS
// ==========================================
type CreateProjectScreenProps = {
  navigation: NativeStackNavigationProp<any>;
};

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

// ==========================================
// MAIN COMPONENT: CreateProjectScreen
// ==========================================
export default function CreateProjectScreen({ navigation }: CreateProjectScreenProps) {
  const { addProject } = useProjects();
  const [projectName, setProjectName] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [showItemModal, setShowItemModal] = useState(false);
  const [modalCategory, setModalCategory] = useState<Category | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [nameError, setNameError] = useState(false);

  const handleCategorySelect = (categoryId: string) => {
    setSelectedCategory(categoryId);

    if (!projectName.trim()) {
      setNameError(true);
      return;
    }

    setNameError(false);
    const category = categories.find(c => c.id === categoryId);
    if (category) {
      setModalCategory(category);
      setSearchQuery('');
      setShowItemModal(true);
    }
  };

  const filteredModalItems = demoItems.filter(item => {
    const matchesCategory = item.category === modalCategory?.id;
    const matchesSearch = item.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  const handleItemSelect = (item: LibraryItem) => {
    setShowItemModal(false);
    const category = modalCategory;
    // Navigate to Workshop with item + new project info
    navigation.getParent()?.navigate('Workshop', {
      selectedItem: {
        name: item.name,
        emoji: item.emoji,
        stat: item.stat,
        rarity: item.rarity,
        category: item.category,
      },
      newProject: {
        name: projectName.trim(),
        category: category?.id || 'weapons',
        emoji: category?.emoji || '⚔️',
      },
    });
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
          <Text style={styles.titleEmoji}>✨</Text>
          <Text style={styles.title}>Neues Projekt</Text>
        </View>
        <View style={{ width: sizing.touchMinimum }} />
      </View>

      {/* Content */}
      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* Project Name Input */}
        <View style={styles.section}>
          <Text style={styles.sectionLabel}>📝 Projekt-Name</Text>
          <TextInput
            style={[styles.input, nameError && styles.inputError]}
            value={projectName}
            onChangeText={(text) => {
              setProjectName(text);
              if (text.trim()) setNameError(false);
            }}
            placeholder="z.B. Super Schwert Pack"
            placeholderTextColor={colors.textMuted}
            autoCapitalize="words"
            autoCorrect={false}
          />
          {nameError && (
            <Text style={styles.errorText}>Bitte gib einen Namen ein!</Text>
          )}
        </View>

        {/* Category Selection */}
        <View style={styles.section}>
          <Text style={styles.sectionLabel}>🎯 Was möchtest du erstellen?</Text>
          <View style={styles.categoryGrid}>
            {categories.map((category) => (
              <TouchableOpacity
                key={category.id}
                style={[
                  styles.categoryCard,
                  selectedCategory === category.id && styles.categoryCardSelected,
                ]}
                onPress={() => handleCategorySelect(category.id)}
                activeOpacity={0.7}
              >
                <Text style={styles.categoryEmoji}>{category.emoji}</Text>
                <Text style={styles.categoryName}>{category.name}</Text>
                <Text style={styles.categoryDescription}>{category.description}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        {/* Bottom Padding */}
        <View style={{ height: spacing.xxl }} />
      </ScrollView>

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
              onPress={() => setShowItemModal(false)}
              hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
            >
              <Text style={styles.modalCloseBtnText}>←</Text>
            </TouchableOpacity>
            <Text style={styles.modalTitle}>
              {modalCategory?.emoji} {modalCategory?.name} auswählen
            </Text>
            <View style={{ width: sizing.touchMinimum }} />
          </View>

          {/* Search Bar */}
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

          {/* Item Grid */}
          <ScrollView style={styles.modalContent} showsVerticalScrollIndicator={false}>
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

            <View style={{ height: spacing.xxl }} />
          </ScrollView>
        </SafeAreaView>
      </Modal>
    </SafeAreaView>
  );
}

// ==========================================
// STYLES
// ==========================================
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
  },
  titleEmoji: {
    fontSize: 24,
  },
  title: {
    fontSize: typography.xl,
    fontWeight: typography.bold,
    color: colors.text,
  },
  content: {
    flex: 1,
    padding: spacing.xl,
  },
  section: {
    marginBottom: spacing.xxl,
  },
  sectionLabel: {
    fontSize: typography.lg,
    fontWeight: typography.semibold,
    color: colors.text,
    marginBottom: spacing.lg,
  },
  input: {
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
    borderRadius: sizing.radiusLarge,
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.lg,
    fontSize: typography.md,
    color: colors.text,
    minHeight: 60,
  },
  inputError: {
    borderColor: colors.error,
  },
  errorText: {
    color: colors.error,
    fontSize: typography.sm,
    marginTop: spacing.sm,
  },
  categoryGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.md,
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
  categoryCardSelected: {
    backgroundColor: colors.primaryAlpha,
    borderColor: colors.primary,
    borderWidth: 3,
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

  // Modal Styles
  modalContainer: {
    flex: 1,
    backgroundColor: colors.background,
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
