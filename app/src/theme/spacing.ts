// GameForge Studio - Spacing & Sizing
// Kinderfreundlich: große Touch-Targets!

export const spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  xxl: 24,
  xxxl: 32,
} as const;

export const sizing = {
  // Touch targets - minimum 44px, ideal 60px for kids
  touchMinimum: 44,
  touchIdeal: 60,

  // Icons
  iconSmall: 20,
  iconMedium: 24,
  iconLarge: 32,
  iconXLarge: 56,

  // Border radius
  radiusSmall: 8,
  radiusMedium: 12,
  radiusLarge: 16,
  radiusXLarge: 20,
  radiusFull: 9999,

  // Header
  headerHeight: 60,

  // Bottom navigation
  bottomNavHeight: 80,

  // Cards
  cardMinHeight: 80,
} as const;

export const typography = {
  // Font sizes
  xs: 11,
  sm: 13,
  md: 15,
  lg: 18,
  xl: 20,
  xxl: 24,
  xxxl: 32,

  // Font weights
  regular: '400' as const,
  medium: '500' as const,
  semibold: '600' as const,
  bold: '700' as const,
} as const;
