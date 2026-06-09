// app_brand_logo.dart

import 'package:flutter/material.dart';

/// Predefined size presets for [AppBrandLogo].
enum BrandLogoSize {
  /// 40 × 40 logical pixels — app bars, list tiles.
  small(40),

  /// 72 × 72 logical pixels — auth screen headers.
  medium(72),

  /// 140 × 140 logical pixels — splash screen.
  large(140);

  final double dimension;
  const BrandLogoSize(this.dimension);
}

/// Renders the official CampusTrace **in-app brand logo** (`app_logo_2.png`).
///
/// This widget is the single source of truth for displaying the brand identity
/// inside the application UI (splash, auth screens, app bars, profile, etc.).
///
/// For the Android **launcher icon**, `app_logo_1.png` is used instead —
/// configured via `flutter_launcher_icons` in `pubspec.yaml`.
///
/// Usage:
/// ```dart
/// const AppBrandLogo(size: BrandLogoSize.medium)
/// const AppBrandLogo(size: BrandLogoSize.large)
/// AppBrandLogo.custom(dimension: 96) // arbitrary size
/// ```
class AppBrandLogo extends StatelessWidget {
  /// The display size of the logo in logical pixels.
  /// When using a [BrandLogoSize] preset, set via [_sizePreset].
  /// When using a custom dimension, set directly.
  final double? _customDimension;
  final BrandLogoSize? _sizePreset;

  /// Creates a brand logo with a predefined [BrandLogoSize].
  const AppBrandLogo({super.key, required BrandLogoSize size})
      : _sizePreset = size,
        _customDimension = null;

  /// Creates a brand logo with a custom [dimension] in logical pixels.
  const AppBrandLogo.custom({super.key, required double dimension})
      : _customDimension = dimension,
        _sizePreset = null;

  /// Resolved dimension from either preset or custom value.
  double get dimension => _customDimension ?? _sizePreset!.dimension;

  /// The asset path for the in-app brand logo.
  static const String assetPath = 'assets/images/app_logo_2.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: dimension,
      height: dimension,
      fit: BoxFit.contain,
    );
  }
}
