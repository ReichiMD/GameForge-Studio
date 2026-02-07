import 'package:flutter/material.dart';

/// GameForge Studio - Color Palette
/// Minecraft-inspired dark theme
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF8B5CF6); // Purple - Main accent
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF7C3AED);

  // Secondary Colors
  static const Color success = Color(0xFF10B981); // Green - Positive actions
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  static const Color info = Color(0xFF3B82F6); // Blue - Information
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  static const Color warning = Color(0xFFF59E0B); // Orange - Warnings
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444); // Red - Errors
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  // Background Colors (Dark Theme)
  static const Color background = Color(0xFF111827); // Darkest
  static const Color surface = Color(0xFF1F2937); // Cards, containers
  static const Color surfaceLight = Color(0xFF374151); // Elevated elements

  // Text Colors
  static const Color text = Color(0xFFF9FAFB); // Primary text
  static const Color textSecondary = Color(0xFF9CA3AF); // Secondary text
  static const Color textMuted = Color(0xFF6B7280); // Muted/placeholder

  // Border Colors
  static const Color border = Color(0xFF374151);
  static const Color borderLight = Color(0xFF4B5563);

  // Rarity Colors (for items)
  static const Color rarityCommon = Color(0xFF6B7280);
  static const Color rarityRare = Color(0xFF3B82F6);
  static const Color rarityEpic = Color(0xFF8B5CF6);
  static const Color rarityLegendary = Color(0xFFF59E0B);

  // Status Colors
  static const Color statusDraft = Color(0xFFFEF3C7);
  static const Color statusDraftText = Color(0xFF92400E);
  static const Color statusReady = Color(0xFFD1FAE5);
  static const Color statusReadyText = Color(0xFF065F46);

  // Transparent variants
  static const Color primaryAlpha = Color(0x338B5CF6); // 20% opacity
  static const Color successAlpha = Color(0x3310B981); // 20% opacity
}
