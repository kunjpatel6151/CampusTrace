// app_colors.dart

import 'package:flutter/material.dart';

/// Centralized color palette for CampusTrace.
/// Derived from the Material 3 design tokens used in the Stitch mockup.
class AppColors {
  AppColors._();

  // ── Primary ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3525CD);
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFDAD7FF);
  static const Color primaryFixed = Color(0xFFE2DFFF);
  static const Color primaryFixedDim = Color(0xFFC3C0FF);
  static const Color onPrimaryFixed = Color(0xFF0F0069);
  static const Color onPrimaryFixedVariant = Color(0xFF3323CC);
  static const Color inversePrimary = Color(0xFFC3C0FF);

  // ── Secondary ────────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF006C49);
  static const Color secondaryContainer = Color(0xFF6CF8BB);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF00714D);
  static const Color secondaryFixed = Color(0xFF6FFBBE);
  static const Color secondaryFixedDim = Color(0xFF4EDEA3);
  static const Color onSecondaryFixed = Color(0xFF002113);
  static const Color onSecondaryFixedVariant = Color(0xFF005236);

  // ── Tertiary ─────────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF960014);
  static const Color tertiaryContainer = Color(0xFFBC1D25);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFFFD0CC);
  static const Color tertiaryFixed = Color(0xFFFFDAD7);
  static const Color tertiaryFixedDim = Color(0xFFFFB3AD);
  static const Color onTertiaryFixed = Color(0xFF410004);
  static const Color onTertiaryFixedVariant = Color(0xFF930013);

  // ── Error ────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Surface / Background ─────────────────────────────────────────────────
  static const Color background = Color(0xFFFAF8FF);
  static const Color onBackground = Color(0xFF161B2B);
  static const Color surface = Color(0xFFFAF8FF);
  static const Color onSurface = Color(0xFF161B2B);
  static const Color onSurfaceVariant = Color(0xFF464555);
  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceDim = Color(0xFFD5D9EF);
  static const Color surfaceVariant = Color(0xFFDDE1F8);
  static const Color surfaceTint = Color(0xFF4D44E3);

  // ── Surface Containers ───────────────────────────────────────────────────
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE3E7FD);
  static const Color surfaceContainerHighest = Color(0xFFDDE1F8);

  // ── Outline ──────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF777587);
  static const Color outlineVariant = Color(0xFFC7C4D8);

  // ── Inverse ──────────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF2B3040);
  static const Color inverseOnSurface = Color(0xFFEEF0FF);
}
