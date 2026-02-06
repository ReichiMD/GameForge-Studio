import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  TextInput,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { colors, spacing, sizing, typography } from '../theme';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

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

export default function CreateProjectScreen({ navigation }: CreateProjectScreenProps) {
  const [projectName, setProjectName] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  const handleCategorySelect = (categoryId: string) => {
    setSelectedCategory(categoryId);
  };

  const handleCreateProject = () => {
    if (!projectName.trim() || !selectedCategory) {
      // TODO: Show error message
      return;
    }

    // TODO: Create project logic (AsyncStorage)
    console.log('Create project:', { name: projectName, category: selectedCategory });

    // Navigate back to Home
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
});
