import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  SafeAreaView,
  TextInput,
} from 'react-native';
import { colors, spacing, sizing, typography } from '../theme';

type Rarity = 'common' | 'rare' | 'epic' | 'legendary';
type ItemType = 'weapon' | 'armor' | 'potion' | 'food' | 'block';

interface LibraryItem {
  id: string;
  name: string;
  emoji: string;
  type: ItemType;
  rarity: Rarity;
  stat: string;
}

const demoItems: LibraryItem[] = [
  { id: '1', name: 'Drachenschwert', emoji: '⚔️', type: 'weapon', rarity: 'legendary', stat: '50 DMG' },
  { id: '2', name: 'Diamant Schild', emoji: '🛡️', type: 'armor', rarity: 'epic', stat: '+20 DEF' },
  { id: '3', name: 'Heiltrank', emoji: '🧪', type: 'potion', rarity: 'rare', stat: '+10 HP' },
  { id: '4', name: 'Eis Klinge', emoji: '🗡️', type: 'weapon', rarity: 'rare', stat: '25 DMG' },
  { id: '5', name: 'König Helm', emoji: '👑', type: 'armor', rarity: 'legendary', stat: '+15 DEF' },
  { id: '6', name: 'Goldener Apfel', emoji: '🍎', type: 'food', rarity: 'common', stat: '+5 HP' },
];

const filters = [
  { id: 'all', label: '✨ Alle' },
  { id: 'weapon', label: '⚔️ Waffen' },
  { id: 'armor', label: '🛡️ Rüstung' },
  { id: 'potion', label: '🧪 Tränke' },
  { id: 'food', label: '🍎 Essen' },
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

const typeEmojis: Record<ItemType, string> = {
  weapon: '⚔️',
  armor: '🛡️',
  potion: '🧪',
  food: '🍎',
  block: '🧱',
};

const ItemCard = ({ item }: { item: LibraryItem }) => (
  <TouchableOpacity style={styles.itemCard} activeOpacity={0.7}>
    <View style={styles.itemPreview}>
      <Text style={styles.itemEmoji}>{item.emoji}</Text>
      <View style={[styles.rarityBadge, { backgroundColor: rarityColors[item.rarity] }]}>
        <Text style={styles.rarityText}>{rarityLabels[item.rarity]}</Text>
      </View>
      <TouchableOpacity style={styles.addBtn} activeOpacity={0.8}>
        <Text style={styles.addBtnText}>+</Text>
      </TouchableOpacity>
    </View>
    <View style={styles.itemInfo}>
      <Text style={styles.itemName} numberOfLines={1}>{item.name}</Text>
      <Text style={styles.itemType}>{typeEmojis[item.type]} {item.stat}</Text>
    </View>
  </TouchableOpacity>
);

export default function LibraryScreen() {
  const [activeFilter, setActiveFilter] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  const filteredItems = demoItems.filter(item => {
    const matchesFilter = activeFilter === 'all' || item.type === activeFilter;
    const matchesSearch = item.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.pageTitle}>📚 Item Bibliothek</Text>
        <View style={styles.searchBar}>
          <Text style={styles.searchIcon}>🔍</Text>
          <TextInput
            style={styles.searchInput}
            placeholder="Suche Items..."
            placeholderTextColor={colors.textMuted}
            value={searchQuery}
            onChangeText={setSearchQuery}
          />
        </View>
      </View>

      {/* Filter Tabs */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        style={styles.filterContainer}
        contentContainerStyle={styles.filterContent}
      >
        {filters.map((filter) => (
          <TouchableOpacity
            key={filter.id}
            style={[
              styles.filterTab,
              activeFilter === filter.id && styles.filterTabActive
            ]}
            onPress={() => setActiveFilter(filter.id)}
            activeOpacity={0.7}
          >
            <Text style={[
              styles.filterText,
              activeFilter === filter.id && styles.filterTextActive
            ]}>
              {filter.label}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Item Grid */}
      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        <View style={styles.itemGrid}>
          {filteredItems.map((item) => (
            <ItemCard key={item.id} item={item} />
          ))}
        </View>
        <View style={{ height: spacing.xxl }} />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    backgroundColor: colors.surface,
    padding: spacing.xl,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  pageTitle: {
    fontSize: typography.xl,
    fontWeight: typography.bold,
    color: colors.text,
    marginBottom: spacing.lg,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surfaceLight,
    borderRadius: sizing.radiusMedium,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    gap: spacing.md,
  },
  searchIcon: {
    fontSize: 18,
  },
  searchInput: {
    flex: 1,
    fontSize: typography.md,
    color: colors.text,
  },
  filterContainer: {
    maxHeight: 60,
  },
  filterContent: {
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.lg,
    gap: spacing.sm,
  },
  filterTab: {
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: sizing.radiusXLarge,
    marginRight: spacing.sm,
  },
  filterTabActive: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  filterText: {
    fontSize: typography.sm,
    fontWeight: typography.medium,
    color: colors.textSecondary,
  },
  filterTextActive: {
    color: colors.text,
  },
  content: {
    flex: 1,
    paddingHorizontal: spacing.xl,
  },
  itemGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.md,
  },
  itemCard: {
    width: '48%',
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    overflow: 'hidden',
  },
  itemPreview: {
    height: 120,
    backgroundColor: colors.surfaceLight,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  itemEmoji: {
    fontSize: 56,
  },
  rarityBadge: {
    position: 'absolute',
    top: spacing.sm,
    right: spacing.sm,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: 6,
  },
  rarityText: {
    fontSize: 10,
    fontWeight: typography.bold,
    color: colors.text,
    textTransform: 'uppercase',
  },
  addBtn: {
    position: 'absolute',
    bottom: spacing.sm,
    right: spacing.sm,
    width: 36,
    height: 36,
    backgroundColor: colors.success,
    borderRadius: 18,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: colors.success,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.4,
    shadowRadius: 8,
    elevation: 4,
  },
  addBtnText: {
    fontSize: 20,
    fontWeight: typography.bold,
    color: colors.text,
  },
  itemInfo: {
    padding: spacing.md,
  },
  itemName: {
    fontSize: typography.sm,
    fontWeight: typography.semibold,
    color: colors.text,
    marginBottom: spacing.xs,
  },
  itemType: {
    fontSize: typography.xs,
    color: colors.textSecondary,
  },
});
