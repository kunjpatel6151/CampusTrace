// my_reports_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';

/// Placeholder for the My Reports tab.
/// Will be replaced with the user's submitted reports.
class MyReportsPlaceholderScreen extends StatelessWidget {
  const MyReportsPlaceholderScreen({super.key});

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
          'My Reports',
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
              Icons.assignment_rounded,
              size: 64,
              color: AppColors.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Submissions',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onBackground,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 260,
              child: Text(
                'Manage your lost and found reports here.',
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
