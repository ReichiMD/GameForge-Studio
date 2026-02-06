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

type Rarity = 'common' | 'rare' | 'epic' | 'legendary';

interface LibraryItem {
  id: string;
  name: string;
  emoji: string;
  category: string;
  rarity: Rarity;
  stat: string;
}

const categories: Category[] = [
  { id: 'weapons', name: 'Waffen', emoji: '⚔️', description: 'Schwerter, Äxte, Bögen' },
  { id: 'armor', name: 'Rüstung', emoji: '🛡️', description: 'Helme, Brustpanzer, Hosen' },
  { id: 'mobs', name: 'Mobs', emoji: '👾', description: 'Tiere, Monster, NPCs' },
  { id: 'food', name: 'Nahrung', emoji: '🍖', description: 'Essen, Tränke' },
  { id: 'blocks', name: 'Blöcke', emoji: '🧱', description: 'Baublöcke, Dekorationen' },
  { id: 'tools', name: 'Werkzeuge', emoji: '🔨', description: 'Spitzhacken, Schaufeln' },
];

const demoItems: LibraryItem[] = [
  // Weapons
  { id: 'w1', name: 'Drachenschwert', emoji: '⚔️', category: 'weapons', rarity: 'legendary', stat: '50 DMG' },
  { id: 'w2', name: 'Eis Klinge', emoji: '🗡️', category: 'weapons', rarity: 'rare', stat: '25 DMG' },
  { id: 'w3', name: 'Diamant Schwert', emoji: '⚔️', category: 'weapons', rarity: 'epic', stat: '35 DMG' },
  { id: 'w4', name: 'Stein Schwert', emoji: '🗡️', category: 'weapons', rarity: 'common', stat: '10 DMG' },
  { id: 'w5', name: 'Bogen', emoji: '🏹', category: 'weapons', rarity: 'rare', stat: '20 DMG' },
  { id: 'w6', name: 'Diamant Axt', emoji: '🪓', category: 'weapons', rarity: 'epic', stat: '30 DMG' },
  // Armor
  { id: 'a1', name: 'Diamant Schild', emoji: '🛡️', category: 'armor', rarity: 'epic', stat: '+20 DEF' },
  { id: 'a2', name: 'König Helm', emoji: '👑', category: 'armor', rarity: 'legendary', stat: '+15 DEF' },
  { id: 'a3', name: 'Eisen Brustpanzer', emoji: '🦺', category: 'armor', rarity: 'rare', stat: '+12 DEF' },
  { id: 'a4', name: 'Leder Hose', emoji: '👖', category: 'armor', rarity: 'common', stat: '+5 DEF' },
  // Mobs
  { id: 'm1', name: 'Zombie', emoji: '🧟', category: 'mobs', rarity: 'common', stat: '20 HP' },
  { id: 'm2', name: 'Creeper', emoji: '💚', category: 'mobs', rarity: 'rare', stat: '30 HP' },
  { id: 'm3', name: 'Enderman', emoji: '🖤', category: 'mobs', rarity: 'epic', stat: '40 HP' },
  { id: 'm4', name: 'Drache', emoji: '🐉', category: 'mobs', rarity: 'legendary', stat: '200 HP' },
  // Food
  { id: 'f1', name: 'Goldener Apfel', emoji: '🍎', category: 'food', rarity: 'rare', stat: '+5 HP' },
  { id: 'f2', name: 'Steak', emoji: '🥩', category: 'food', rarity: 'common', stat: '+8 HP' },
  { id: 'f3', name: 'Heiltrank', emoji: '🧪', category: 'food', rarity: 'rare', stat: '+10 HP' },
  { id: 'f4', name: 'Zaubertrank', emoji: '⚗️', category: 'food', rarity: 'epic', stat: '+20 HP' },
  // Blocks
  { id: 'b1', name: 'Glowstone', emoji: '✨', category: 'blocks', rarity: 'rare', stat: 'Licht' },
  { id: 'b2', name: 'Obsidian', emoji: '🟪', category: 'blocks', rarity: 'epic', stat: 'Sehr Hart' },
  { id: 'b3', name: 'TNT', emoji: '🧨', category: 'blocks', rarity: 'rare', stat: 'Explosion' },
  { id: 'b4', name: 'Diamant Block', emoji: '💎', category: 'blocks', rarity: 'legendary', stat: 'Deko' },
  // Tools
  { id: 't1', name: 'Diamant Spitzhacke', emoji: '⛏️', category: 'tools', rarity: 'epic', stat: '8 SPD' },
  { id: 't2', name: 'Gold Schaufel', emoji: '🥄', category: 'tools', rarity: 'rare', stat: '10 SPD' },
  { id: 't3', name: 'Netherite Hacke', emoji: '🪓', category: 'tools', rarity: 'legendary', stat: '12 SPD' },
];

const rarityColors: Record<Rarity, string> = {
  common: colors.rarity.common,
  rare: colors.rarity.rare,
  epic: colors.rarity.epic,
  legendary: colors.rarity.legendary,
};

const rarityLabels: Record<Rarity, string> = {
  common: 'Normal',
  rare: 'Selten',
  epic: 'Episch',
  legendary: 'Legendär',
};

// ==========================================
// MAIN COMPONENT: CreateProjectScreen
// ==========================================
export default function CreateProjectScreen({ navigation }: CreateProjectScreenProps) {
  const [projectName, setProjectName] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [showItemModal, setShowItemModal] = useState(false);
  const [modalCategory, setModalCategory] = useState<Category | null>(null);
  const [searchQuery, setSearchQuery] = useState('');

  const handleCategorySelect = (categoryId: string) => {
    const category = categories.find(c => c.id === categoryId);
    if (category) {
      setModalCategory(category);
      setSearchQuery('');
      setShowItemModal(true);
    }
    setSelectedCategory(categoryId);
  };

  const filteredModalItems = demoItems.filter(item => {
    const matchesCategory = item.category === modalCategory?.id;
    const matchesSearch = item.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  const handleItemSelect = (item: LibraryItem) => {
    setShowItemModal(false);
    // Navigate to Workshop tab with selected item
    navigation.getParent()?.navigate('Workshop', {
      selectedItem: {
        name: item.name,
        emoji: item.emoji,
        stat: item.stat,
        rarity: item.rarity,
        category: item.category,
      },
    });
  };

  const handleCreateProject = () => {
    if (!projectName.trim() || !selectedCategory) {
      return;
    }
    console.log('Create project:', { name: projectName, category: selectedCategory });
    navigation.goBack();
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
            style={styles.input}
            value={projectName}
            onChangeText={setProjectName}
            placeholder="z.B. Super Schwert Pack"
            placeholderTextColor={colors.textMuted}
            autoCapitalize="words"
            autoCorrect={false}
          />
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

        {/* Create Button */}
        <TouchableOpacity
          style={[
            styles.createBtn,
            (!projectName.trim() || !selectedCategory) && styles.createBtnDisabled,
          ]}
          onPress={handleCreateProject}
          disabled={!projectName.trim() || !selectedCategory}
          activeOpacity={0.8}
        >
          <Text style={styles.createBtnEmoji}>🚀</Text>
          <Text style={styles.createBtnText}>Projekt erstellen</Text>
        </TouchableOpacity>

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
  createBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.md,
    backgroundColor: colors.success,
    paddingVertical: spacing.xl,
    borderRadius: sizing.radiusLarge,
    marginTop: spacing.lg,
    minHeight: 64,
    shadowColor: colors.success,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 15,
    elevation: 8,
  },
  createBtnDisabled: {
    backgroundColor: colors.surfaceLight,
    shadowOpacity: 0,
    elevation: 0,
  },
  createBtnEmoji: {
    fontSize: 28,
  },
  createBtnText: {
    fontSize: typography.lg,
    fontWeight: typography.semibold,
    color: colors.text,
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
