// discover_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';

/// Placeholder for the Discover tab.
/// Will be replaced with full browsing/search functionality.
class DiscoverPlaceholderScreen extends StatelessWidget {
  const DiscoverPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Discover',
          style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.onBackground,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.travel_explore_rounded,
              size: 64,
              color: AppColors.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Browse Lost & Found',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onBackground,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 260,
              child: Text(
                'Explore lost and found listings from across campus.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
