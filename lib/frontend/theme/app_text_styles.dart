// app_text_styles.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography for CampusTrace.
/// Uses the Inter font family with styles matching the Stitch design tokens.
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Inter';

  // ── Headlines ────────────────────────────────────────────────────────────

  /// Extra-large headline – splash screen title, hero text.
  /// 40px / 48px line-height / bold / -0.02em tracking.
  static const TextStyle headlineXl = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 48 / 40,
    letterSpacing: -0.8, // -0.02em × 40
    color: AppColors.onBackground,
  );

  /// Large headline – section titles on desktop.
  /// 32px / 40px / bold / -0.02em.
  static const TextStyle headlineLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.64,
    color: AppColors.onBackground,
  );

  /// Large headline (mobile variant).
  /// 24px / 32px / bold.
  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    color: AppColors.onBackground,
  );

  /// Medium headline – card titles, dialog titles.
  /// 20px / 28px / semi-bold.
  static const TextStyle headlineMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: AppColors.onBackground,
  );

  // ── Body ─────────────────────────────────────────────────────────────────

  /// Large body text.
  /// 18px / 28px / regular.
  static const TextStyle bodyLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: AppColors.onSurface,
  );

  /// Medium body text – default paragraph style.
  /// 16px / 24px / regular.
  static const TextStyle bodyMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  /// Small body text.
  /// 14px / 20px / regular.
  static const TextStyle bodySm = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  // ── Labels ───────────────────────────────────────────────────────────────

  /// Medium label – buttons, chips, tabs.
  /// 14px / 16px / semi-bold / 0.01em tracking.
  static const TextStyle labelMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 0.14, // 0.01em × 14
    color: AppColors.onSurface,
  );

  /// Small label – status text, captions.
  /// 12px / 14px / semi-bold.
  static const TextStyle labelSm = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 14 / 12,
    color: AppColors.outline,
  );
}
