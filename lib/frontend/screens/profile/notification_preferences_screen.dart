import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _recoveryEnabled = true;
  bool _matchingEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader('General'),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive alerts directly on your device.',
            value: _pushEnabled,
            onChanged: (val) => setState(() => _pushEnabled = val),
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive daily digests and important updates via email.',
            value: _emailEnabled,
            onChanged: (val) => setState(() => _emailEnabled = val),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.outlineVariant, height: 1, thickness: 0.5),
          const SizedBox(height: 16),
          _buildSectionHeader('Activity'),
          _buildSwitchTile(
            title: 'Recovery Updates',
            subtitle: 'Get notified when your reported item changes status.',
            value: _recoveryEnabled,
            onChanged: (val) => setState(() => _recoveryEnabled = val),
          ),
          _buildSwitchTile(
            title: 'New Matching Reports',
            subtitle: 'Alerts when a found item matches your lost report.',
            value: _matchingEnabled,
            onChanged: (val) => setState(() => _matchingEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.primary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.onPrimary,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: AppColors.outline,
      inactiveTrackColor: AppColors.surfaceContainerHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        title,
        style: AppTextStyles.labelMd.copyWith(
          color: AppColors.onBackground,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: AppTextStyles.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
