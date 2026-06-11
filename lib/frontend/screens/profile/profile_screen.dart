import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';

import 'package:campus_trace/frontend/screens/profile/edit_profile_screen.dart';
import 'package:campus_trace/frontend/screens/profile/notification_preferences_screen.dart';
import 'package:campus_trace/frontend/screens/profile/about_screen.dart';
import 'package:campus_trace/frontend/screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          'Profile',
          style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildAchievementsSection(),
            const SizedBox(height: 32),
            _buildAccountSection(context),
            const SizedBox(height: 32),
            _buildSignOut(context),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryContainer, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'JD',
              style: AppTextStyles.headlineXl.copyWith(
                color: AppColors.primary,
                fontSize: 48,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'John Doe',
          style: AppTextStyles.headlineLgMobile.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 16, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              'john.doe@campus.edu',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              title: 'Reports\nSubmitted',
              value: '12',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              title: 'Items\nRecovered',
              value: '8',
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              title: 'Recovery\nRate',
              value: '66%',
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Achievements',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.outline),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            children: [
              _AchievementChip(icon: Icons.flag_rounded, label: 'First Report', color: AppColors.primary),
              const SizedBox(width: 8),
              _AchievementChip(icon: Icons.volunteer_activism_rounded, label: 'Helpful Finder', color: AppColors.secondary),
              const SizedBox(width: 8),
              _AchievementChip(icon: Icons.emoji_events_rounded, label: 'Recovery Champion', color: AppColors.tertiary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal details',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.outlineVariant),
                _SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notification Preferences',
                  subtitle: 'Manage your alerts',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPreferencesScreen()));
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.outlineVariant),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About CampusTrace',
                  subtitle: 'Version and legal information',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOut(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            // Navigate back to login, clearing the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.logout_rounded, size: 20),
          label: const Text('Sign Out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineLg.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _AchievementChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Match container if it's the only one, or top/bottom
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMd.copyWith(color: AppColors.onBackground, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant),
          ],
        ),
      ),
    );
  }
}
