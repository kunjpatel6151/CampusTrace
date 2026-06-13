import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';

import 'package:campus_trace/frontend/screens/profile/edit_profile_screen.dart';
import 'package:campus_trace/frontend/screens/profile/notification_preferences_screen.dart';
import 'package:campus_trace/frontend/screens/profile/about_screen.dart';
import 'package:campus_trace/frontend/screens/auth/login_screen.dart';
import 'package:campus_trace/backend/services/auth_service.dart';
import 'package:campus_trace/backend/services/report_service.dart';

import 'package:campus_trace/backend/models/app_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final ReportService _reportService = ReportService();
  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      final user = await _authService.getUserData(uid);
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('User not found'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeroSection(),
                      const SizedBox(height: 24),
                      _buildStatsSection(),
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
    final hasImage = _user?.profileImageUrl != null && _user!.profileImageUrl!.isNotEmpty;
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
            image: hasImage
                ? DecorationImage(
                    image: CachedNetworkImageProvider(_user!.profileImageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: hasImage
              ? null
              : Center(
                  child: Text(
                    _getInitials(_user?.fullName ?? ''),
                    style: AppTextStyles.headlineXl.copyWith(
                      color: AppColors.primary,
                      fontSize: 48,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 16),
        Text(
          _user?.fullName ?? 'Unknown User',
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
              _user?.email ?? '',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_outlined, size: 16, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              (_user?.phoneNumber != null && _user!.phoneNumber!.isNotEmpty)
                  ? _user!.phoneNumber!
                  : 'Not provided',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_user != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Member Since ${DateFormat('MMMM yyyy').format(_user!.createdAt)}',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _user != null ? _reportService.getUserReportStats(_user!.uid) : Future.value({'reportsSubmitted': 0, 'itemsRecovered': 0, 'recoveryRate': 0}),
      builder: (context, snapshot) {
        int reportsSubmitted = 0;
        int itemsRecovered = 0;
        int recoveryRate = 0;

        if (snapshot.hasData) {
          reportsSubmitted = snapshot.data!['reportsSubmitted'] ?? 0;
          itemsRecovered = snapshot.data!['itemsRecovered'] ?? 0;
          recoveryRate = snapshot.data!['recoveryRate'] ?? 0;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Reports\nSubmitted',
                  value: '$reportsSubmitted',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Items\nRecovered',
                  value: '$itemsRecovered',
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Recovery\nRate',
                  value: '$recoveryRate%',
                  color: AppColors.tertiary,
                ),
              ),
            ],
          ),
        );
      }
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
                  onTap: () async {
                    final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                    if (updated == true) {
                      setState(() => _isLoading = true);
                      _loadUser();
                    }
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
          onPressed: () async {
            try {
              await AuthService().signOut();
              if (!context.mounted) return;
              // Navigate back to login, clearing the stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to sign out. Please try again.')),
              );
            }
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
