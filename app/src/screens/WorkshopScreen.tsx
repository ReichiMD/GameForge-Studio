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

// ==========================================
// CONSTANTS (Zeile 13-22)
// ==========================================
const itemColors = [
  { id: 'red', color: '#EF4444' },
  { id: 'orange', color: '#F97316' },
  { id: 'yellow', color: '#EAB308' },
  { id: 'green', color: '#22C55E' },
  { id: 'blue', color: '#3B82F6' },
  { id: 'purple', color: '#8B5CF6' },
  { id: 'pink', color: '#EC4899' },
  { id: 'white', color: '#F9FAFB' },
];

// ==========================================
// COMPONENTS: StatSlider (Zeile 24-48)
// ==========================================
interface SliderProps {
  label: string;
  emoji: string;
  value: number;
  maxValue: number;
  unit?: string;
}

const StatSlider = ({ label, emoji, value, maxValue, unit = '' }: SliderProps) => {
  const percentage = (value / maxValue) * 100;

  return (
    <View style={styles.sliderControl}>
      <View style={styles.sliderHeader}>
        <Text style={styles.sliderLabel}>{emoji} {label}</Text>
        <View style={styles.sliderValue}>
          <Text style={styles.sliderValueText}>{value}{unit}</Text>
        </View>
      </View>
      <View style={styles.sliderTrack}>
        <View style={[styles.sliderFill, { width: `${percentage}%` }]} />
      </View>
    </View>
  );
};

// ==========================================
// COMPONENTS: ToggleSwitch (Zeile 50-68)
// ==========================================
interface ToggleProps {
  label: string;
  emoji: string;
  active: boolean;
  onToggle: () => void;
}

const ToggleSwitch = ({ label, emoji, active, onToggle }: ToggleProps) => (
  <TouchableOpacity
    style={styles.toggleControl}
    onPress={onToggle}
    activeOpacity={0.7}
  >
    <Text style={styles.toggleLabel}>{emoji} {label}</Text>
    <View style={[styles.toggleSwitch, active && styles.toggleSwitchActive]}>
      <View style={[styles.toggleKnob, active && styles.toggleKnobActive]} />
    </View>
  </TouchableOpacity>
);

// ==========================================
// MAIN COMPONENT: WorkshopScreen (Zeile 70-172)
// ==========================================
export default function WorkshopScreen() {
  const [itemName, setItemName] = useState('Mein Super Schwert');
  const [selectedColor, setSelectedColor] = useState('blue');
  const [effects, setEffects] = useState({
    fire: true,
    glow: false,
    ice: false,
  });

  const toggleEffect = (effect: keyof typeof effects) => {
    setEffects(prev => ({ ...prev, [effect]: !prev[effect] }));
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity style={styles.backBtn}>
          <Text style={styles.backBtnText}>←</Text>
        </TouchableOpacity>
        <Text style={styles.pageTitle}>🔧 Item Editor</Text>
        <TouchableOpacity style={styles.saveBtn}>
          <Text style={styles.saveBtnText}>💾</Text>
        </TouchableOpacity>
      </View>

      {/* Item Preview */}
      <View style={styles.previewSection}>
        <View style={styles.itemIconLarge}>
          <Text style={styles.itemEmojiLarge}>⚔️</Text>
        </View>
        <TextInput
          style={styles.nameInput}
          value={itemName}
          onChangeText={setItemName}
          placeholder="Item Name..."
          placeholderTextColor={colors.textMuted}
        />
      </View>

      {/* Content */}
      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* Stats Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>📊 EIGENSCHAFTEN</Text>
          <StatSlider label="Schaden" emoji="💥" value={35} maxValue={50} />
          <StatSlider label="Geschwindigkeit" emoji="⚡" value={1.2} maxValue={3} unit="x" />
          <StatSlider label="Haltbarkeit" emoji="🛡️" value={500} maxValue={600} />
        </View>

        {/* Color Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>🎨 FARBE</Text>
          <View style={styles.colorGrid}>
            {itemColors.map((c) => (
              <TouchableOpacity
                key={c.id}
                style={[
                  styles.colorBtn,
                  { backgroundColor: c.color },
                  selectedColor === c.id && styles.colorBtnActive
                ]}
                onPress={() => setSelectedColor(c.id)}
                activeOpacity={0.7}
              />
            ))}
          </View>
        </View>

        {/* Effects Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>✨ SPEZIAL-EFFEKTE</Text>
          <ToggleSwitch
            label="Feuer-Schaden"
            emoji="🔥"
            active={effects.fire}
            onToggle={() => toggleEffect('fire')}
          />
          <ToggleSwitch
            label="Leuchtend"
            emoji="💫"
            active={effects.glow}
            onToggle={() => toggleEffect('glow')}
          />
          <ToggleSwitch
            label="Eis-Effekt"
            emoji="🧊"
            active={effects.ice}
            onToggle={() => toggleEffect('ice')}
          />
        </View>

        {/* Create Button */}
        <TouchableOpacity style={styles.createBtn} activeOpacity={0.8}>
          <Text style={styles.createBtnEmoji}>🚀</Text>
          <Text style={styles.createBtnText}>Item erstellen</Text>
        </TouchableOpacity>

        <View style={{ height: spacing.xxl }} />
      </ScrollView>
    </SafeAreaView>
  );
}

// ==========================================
// STYLES (Zeile 174-373)
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
    backgroundColor: colors.surfaceLight,
    borderRadius: sizing.radiusMedium,
    justifyContent: 'center',
    alignItems: 'center',
  },
  backBtnText: {
    fontSize: 20,
    color: colors.text,
  },
  pageTitle: {
    fontSize: typography.lg,
    fontWeight: typography.bold,
    color: colors.text,
  },
  saveBtn: {
    width: sizing.touchMinimum,
    height: sizing.touchMinimum,
    backgroundColor: colors.success,
    borderRadius: sizing.radiusMedium,
    justifyContent: 'center',
    alignItems: 'center',
  },
  saveBtnText: {
    fontSize: 20,
  },
  previewSection: {
    alignItems: 'center',
    paddingVertical: spacing.xxl,
    backgroundColor: colors.surface,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  itemIconLarge: {
    width: 100,
    height: 100,
    backgroundColor: colors.surfaceLight,
    borderRadius: sizing.radiusXLarge,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.md,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.3,
    shadowRadius: 20,
    elevation: 10,
  },
  itemEmojiLarge: {
    fontSize: 56,
  },
  nameInput: {
    fontSize: typography.xl,
    fontWeight: typography.bold,
    color: colors.text,
    textAlign: 'center',
    padding: spacing.sm,
    borderBottomWidth: 2,
    borderBottomColor: 'transparent',
    minWidth: 200,
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
  sliderControl: {
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  sliderHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  sliderLabel: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
  },
  sliderValue: {
    backgroundColor: colors.surfaceLight,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radiusSmall,
  },
  sliderValueText: {
    fontSize: typography.sm,
    fontWeight: typography.bold,
    color: colors.primary,
  },
  sliderTrack: {
    height: 8,
    backgroundColor: colors.surfaceLight,
    borderRadius: 4,
    overflow: 'hidden',
  },
  sliderFill: {
    height: '100%',
    backgroundColor: colors.primary,
    borderRadius: 4,
  },
  colorGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.md,
  },
  colorBtn: {
    width: 48,
    height: 48,
    borderRadius: sizing.radiusMedium,
    borderWidth: 3,
    borderColor: 'transparent',
  },
  colorBtnActive: {
    borderColor: colors.text,
  },
  toggleControl: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusLarge,
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  toggleLabel: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
  },
  toggleSwitch: {
    width: 56,
    height: 32,
    backgroundColor: colors.surfaceLight,
    borderRadius: 16,
    padding: 4,
  },
  toggleSwitchActive: {
    backgroundColor: colors.success,
  },
  toggleKnob: {
    width: 24,
    height: 24,
    backgroundColor: colors.text,
    borderRadius: 12,
  },
  toggleKnobActive: {
    marginLeft: 24,
  },
  createBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.md,
    backgroundColor: colors.success,
    paddingVertical: spacing.lg,
    borderRadius: sizing.radiusLarge,
    shadowColor: colors.success,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 15,
    elevation: 8,
  },
  createBtnEmoji: {
    fontSize: 24,
  },
  createBtnText: {
    fontSize: typography.lg,
    fontWeight: typography.bold,
    color: colors.text,
  },
});
