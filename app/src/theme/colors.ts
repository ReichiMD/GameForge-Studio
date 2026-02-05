// GameForge Studio - Color Palette
// Minecraft-inspired dark theme

export const colors = {
  // Primary Colors
  primary: '#8B5CF6',      // Purple - Main accent
  primaryLight: '#A78BFA',
  primaryDark: '#7C3AED',

  // Secondary Colors
  success: '#10B981',      // Green - Positive actions
  successLight: '#34D399',
  successDark: '#059669',

  info: '#3B82F6',         // Blue - Information
  infoLight: '#60A5FA',
  infoDark: '#2563EB',

  warning: '#F59E0B',      // Orange - Warnings
  warningLight: '#FBBF24',
  warningDark: '#D97706',

  error: '#EF4444',        // Red - Errors
  errorLight: '#F87171',
  errorDark: '#DC2626',

  // Background Colors (Dark Theme)
  background: '#111827',   // Darkest
  surface: '#1F2937',      // Cards, containers
  surfaceLight: '#374151', // Elevated elements

  // Text Colors
  text: '#F9FAFB',         // Primary text
  textSecondary: '#9CA3AF', // Secondary text
  textMuted: '#6B7280',    // Muted/placeholder

  // Border Colors
  border: '#374151',
  borderLight: '#4B5563',

  // Rarity Colors (for items)
  rarity: {
    common: '#6B7280',
    rare: '#3B82F6',
    epic: '#8B5CF6',
    legendary: '#F59E0B',
  },

  // Status Colors
  status: {
    draft: '#FEF3C7',
    draftText: '#92400E',
    ready: '#D1FAE5',
    readyText: '#065F46',
  },

  // Transparent variants
  primaryAlpha: 'rgba(139, 92, 246, 0.2)',
  successAlpha: 'rgba(16, 185, 129, 0.2)',
} as const;

export type ColorKeys = keyof typeof colors;
