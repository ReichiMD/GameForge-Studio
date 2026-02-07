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

interface SettingItemProps {
  emoji: string;
  label: string;
  value?: string;
  onPress?: () => void;
  showArrow?: boolean;
}

const SettingItem = ({ emoji, label, value, onPress, showArrow = true }: SettingItemProps) => (
  <TouchableOpacity
    style={styles.settingItem}
    onPress={onPress}
    activeOpacity={0.7}
    disabled={!onPress}
  >
    <Text style={styles.settingEmoji}>{emoji}</Text>
    <View style={styles.settingContent}>
      <Text style={styles.settingLabel}>{label}</Text>
      {value && <Text style={styles.settingValue}>{value}</Text>}
    </View>
    {showArrow && <Text style={styles.settingArrow}>→</Text>}
  </TouchableOpacity>
);

export default function SettingsScreen() {
  const [githubToken, setGithubToken] = useState('');
  const [showToken, setShowToken] = useState(false);

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.pageTitle}>⚙️ Einstellungen</Text>
      </View>

      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* GitHub Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>🐙 GITHUB VERBINDUNG</Text>

          <View style={styles.tokenCard}>
            <View style={styles.tokenHeader}>
              <Text style={styles.tokenLabel}>🔑 GitHub Token</Text>
              <TouchableOpacity onPress={() => setShowToken(!showToken)}>
                <Text style={styles.toggleText}>{showToken ? '🙈 Verbergen' : '👁️ Zeigen'}</Text>
              </TouchableOpacity>
            </View>
            <TextInput
              style={styles.tokenInput}
              value={githubToken}
              onChangeText={setGithubToken}
              placeholder="ghp_xxxxxxxxxxxx"
              placeholderTextColor={colors.textMuted}
              secureTextEntry={!showToken}
              autoCapitalize="none"
              autoCorrect={false}
            />
            <Text style={styles.tokenHint}>
              💡 Brauchst du für die Werkstatt-Verbindung
            </Text>
          </View>

          <SettingItem
            emoji="📂"
            label="Repository"
            value="GameForge-Studio"
          />
          <SettingItem
            emoji="🔗"
            label="Werkstatt Status"
            value="✅ Verbunden"
          />
        </View>

        {/* Appearance Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>🎨 DARSTELLUNG</Text>

          <SettingItem
            emoji="🌙"
            label="Dark Mode"
            value="An"
          />
          <SettingItem
            emoji="📏"
            label="Button Größe"
            value="Groß (60px)"
          />
          <SettingItem
            emoji="🌍"
            label="Sprache"
            value="Deutsch"
          />
        </View>

        {/* Info Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>ℹ️ INFO</Text>

          <SettingItem
            emoji="📱"
            label="App Version"
            value="0.0.1"
            showArrow={false}
          />
          <SettingItem
            emoji="❓"
            label="Hilfe"
          />
          <SettingItem
            emoji="💬"
            label="Feedback"
          />
        </View>

        {/* Danger Zone */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.error }]}>⚠️ GEFAHRENZONE</Text>

          <TouchableOpacity style={styles.dangerBtn} activeOpacity={0.7}>
            <Text style={styles.dangerBtnText}>🗑️ Alle Projekte löschen</Text>
          </TouchableOpacity>
        </View>

        <View style={{ height: spacing.xxxl }} />
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
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.xl,
    backgroundColor: colors.surface,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  pageTitle: {
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
  sectionTitle: {
    fontSize: typography.sm,
    color: colors.textSecondary,
    marginBottom: spacing.md,
    letterSpacing: 0.5,
  },
  settingItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    marginBottom: spacing.md,
    gap: spacing.md,
  },
  settingEmoji: {
    fontSize: 24,
  },
  settingContent: {
    flex: 1,
  },
  settingLabel: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
  },
  settingValue: {
    fontSize: typography.sm,
    color: colors.textSecondary,
    marginTop: 2,
  },
  settingArrow: {
    fontSize: 18,
    color: colors.textMuted,
  },
  tokenCard: {
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  tokenHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  tokenLabel: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
  },
  toggleText: {
    fontSize: typography.sm,
    color: colors.primary,
  },
  tokenInput: {
    backgroundColor: colors.surfaceLight,
    borderRadius: sizing.radiusMedium,
    padding: spacing.md,
    fontSize: typography.md,
    color: colors.text,
    fontFamily: 'monospace',
    marginBottom: spacing.sm,
  },
  tokenHint: {
    fontSize: typography.xs,
    color: colors.textMuted,
  },
  dangerBtn: {
    backgroundColor: 'rgba(239, 68, 68, 0.1)',
    borderWidth: 1,
    borderColor: colors.error,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    alignItems: 'center',
  },
  dangerBtnText: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.error,
  },
});
