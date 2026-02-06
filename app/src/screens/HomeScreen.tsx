import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { colors, spacing, sizing, typography } from '../theme';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

// ==========================================
// TYPES & MOCK DATA (Zeile 13-27)
// ==========================================
type HomeScreenProps = {
  navigation: NativeStackNavigationProp<any>;
};

// Demo-Projekte (später aus AsyncStorage)
const demoProjects = [
  { id: '1', name: 'Super Schwert Pack', emoji: '⚔️', items: 3, status: 'ready' },
  { id: '2', name: 'Coole Rüstungen', emoji: '🛡️', items: 5, status: 'draft' },
  { id: '3', name: 'Magische Tränke', emoji: '🧪', items: 2, status: 'draft' },
];

type ProjectStatus = 'ready' | 'draft';

interface Project {
  id: string;
  name: string;
  emoji: string;
  items: number;
  status: ProjectStatus;
}

// ==========================================
// COMPONENTS: ProjectCard (Zeile 37-63)
// ==========================================
const ProjectCard = ({ project }: { project: Project }) => (
  <TouchableOpacity style={styles.projectCard} activeOpacity={0.7}>
    <View style={styles.projectIcon}>
      <Text style={styles.projectEmoji}>{project.emoji}</Text>
    </View>
    <View style={styles.projectInfo}>
      <Text style={styles.projectName}>{project.name}</Text>
      <View style={styles.projectMeta}>
        <View style={styles.itemCount}>
          <Text style={styles.itemCountText}>{project.items} Items</Text>
        </View>
        <View style={[
          styles.statusBadge,
          project.status === 'ready' ? styles.statusReady : styles.statusDraft
        ]}>
          <Text style={[
            styles.statusText,
            project.status === 'ready' ? styles.statusReadyText : styles.statusDraftText
          ]}>
            {project.status === 'ready' ? '✓ Fertig' : '⏳ Entwurf'}
          </Text>
        </View>
      </View>
    </View>
    <Text style={styles.projectArrow}>→</Text>
  </TouchableOpacity>
);

// ==========================================
// MAIN COMPONENT: HomeScreen (Zeile 64-107)
// ==========================================
export default function HomeScreen({ navigation }: HomeScreenProps) {
  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity style={styles.burgerBtn}>
          <View style={styles.burgerLine} />
          <View style={styles.burgerLine} />
          <View style={styles.burgerLine} />
        </TouchableOpacity>
        <View style={styles.titleContainer}>
          <Text style={styles.titleEmoji}>⚒️</Text>
          <Text style={styles.title}>GameForge</Text>
          <View style={styles.badge}>
            <Text style={styles.badgeText}>Minecraft</Text>
          </View>
        </View>
        <View style={{ width: sizing.touchMinimum }} />
      </View>

      {/* Content */}
      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* New Project Button */}
        <TouchableOpacity
          style={styles.newProjectBtn}
          activeOpacity={0.8}
          onPress={() => navigation.navigate('CreateProject')}
        >
          <Text style={styles.newProjectEmoji}>✨</Text>
          <Text style={styles.newProjectText}>Neues Projekt</Text>
        </TouchableOpacity>

        {/* Section Title */}
        <Text style={styles.sectionTitle}>📁 Meine Projekte</Text>

        {/* Project List */}
        {demoProjects.map((project) => (
          <ProjectCard key={project.id} project={project} />
        ))}

        {/* Bottom Padding */}
        <View style={{ height: spacing.xxl }} />
      </ScrollView>
    </SafeAreaView>
  );
}

// ==========================================
// STYLES (Zeile 109-263)
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
  burgerBtn: {
    width: sizing.touchMinimum,
    height: sizing.touchMinimum,
    justifyContent: 'center',
    alignItems: 'center',
    gap: 5,
  },
  burgerLine: {
    width: 24,
    height: 3,
    backgroundColor: colors.textSecondary,
    borderRadius: 2,
    marginVertical: 2,
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
  badge: {
    backgroundColor: colors.primary,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radiusMedium,
  },
  badgeText: {
    fontSize: typography.xs,
    fontWeight: typography.semibold,
    color: colors.text,
  },
  content: {
    flex: 1,
    padding: spacing.xl,
  },
  newProjectBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.md,
    backgroundColor: colors.primary,
    paddingVertical: spacing.xl,
    borderRadius: sizing.radiusLarge,
    marginBottom: spacing.xxl,
    minHeight: 64,
    shadowColor: colors.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 15,
    elevation: 8,
  },
  newProjectEmoji: {
    fontSize: 28,
  },
  newProjectText: {
    fontSize: typography.lg,
    fontWeight: typography.semibold,
    color: colors.text,
  },
  sectionTitle: {
    fontSize: typography.md,
    color: colors.textSecondary,
    marginBottom: spacing.lg,
  },
  projectCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    marginBottom: spacing.md,
    gap: spacing.lg,
  },
  projectIcon: {
    width: sizing.touchIdeal,
    height: sizing.touchIdeal,
    backgroundColor: colors.surfaceLight,
    borderRadius: sizing.radiusMedium,
    justifyContent: 'center',
    alignItems: 'center',
  },
  projectEmoji: {
    fontSize: 32,
  },
  projectInfo: {
    flex: 1,
  },
  projectName: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
    marginBottom: spacing.xs,
  },
  projectMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  itemCount: {
    backgroundColor: colors.surfaceLight,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radiusSmall,
  },
  itemCountText: {
    fontSize: typography.xs,
    color: colors.text,
  },
  statusBadge: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radiusSmall,
  },
  statusReady: {
    backgroundColor: colors.status.ready,
  },
  statusDraft: {
    backgroundColor: colors.status.draft,
  },
  statusText: {
    fontSize: typography.xs,
    fontWeight: typography.semibold,
  },
  statusReadyText: {
    color: colors.status.readyText,
  },
  statusDraftText: {
    color: colors.status.draftText,
  },
  projectArrow: {
    fontSize: 20,
    color: colors.textMuted,
  },
});
