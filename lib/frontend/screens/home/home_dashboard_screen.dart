// home_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/frontend/widgets/app_brand_logo.dart';

/// User-focused Home Dashboard for CampusTrace.
///
/// Displays greeting, lightweight stats, recent lost/found activity feed,
/// and a Report Item FAB. Uses mock data only — no backend logic.
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Top App Bar ──────────────────────────────────────────────
          _buildAppBar(context),

          // ── Body content ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Greeting
                const _GreetingSection(),
                const SizedBox(height: 24),

                // Stats
                const _SectionHeader(title: 'Overview'),
                const SizedBox(height: 14),
                const _StatsRow(),
                const SizedBox(height: 28),

                // Recent Lost Items
                const _SectionHeader(
                  title: 'Recent Lost Items',
                  trailing: 'View All',
                ),
                const SizedBox(height: 14),
                ..._buildMockLostItems(),
                const SizedBox(height: 28),

                // Recent Found Items
                const _SectionHeader(
                  title: 'Recent Found Items',
                  trailing: 'View All',
                ),
                const SizedBox(height: 14),
                ..._buildMockFoundItems(),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const AppBrandLogo(size: BrandLogoSize.small),
          const SizedBox(width: 10),
          Text(
            'CampusTrace',
            style: AppTextStyles.headlineMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Badge(
            smallSize: 8,
            backgroundColor: AppColors.tertiary,
            child: const Icon(Icons.notifications_outlined),
          ),
          color: AppColors.onSurfaceVariant,
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              // TODO: Navigate to Profile
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: const Icon(
                Icons.person_rounded,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // TODO: Navigate to Report Item
      },
      backgroundColor: AppColors.primaryContainer,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: Text(
        'Report Item',
        style: AppTextStyles.labelMd.copyWith(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static List<Widget> _buildMockLostItems() {
    final items = [
      _MockItem(
        title: 'MacBook Pro Charger',
        location: 'Library, 2nd Floor',
        date: 'Jun 8, 2026',
        status: 'Lost',
        statusColor: AppColors.tertiary,
        icon: Icons.laptop_mac_rounded,
      ),
      _MockItem(
        title: 'Student ID Card',
        location: 'Science Building',
        date: 'Jun 7, 2026',
        status: 'Lost',
        statusColor: AppColors.tertiary,
        icon: Icons.badge_rounded,
      ),
      _MockItem(
        title: 'Blue Water Bottle',
        location: 'Cafeteria',
        date: 'Jun 7, 2026',
        status: 'Lost',
        statusColor: AppColors.tertiary,
        icon: Icons.water_drop_rounded,
      ),
    ];
    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _ItemCard(item: item),
    )).toList();
  }

  static List<Widget> _buildMockFoundItems() {
    final items = [
      _MockItem(
        title: 'AirPods Pro Case',
        location: 'Gym Locker Room',
        date: 'Jun 9, 2026',
        status: 'Found',
        statusColor: AppColors.secondary,
        icon: Icons.headphones_rounded,
      ),
      _MockItem(
        title: 'Black Umbrella',
        location: 'Main Entrance',
        date: 'Jun 8, 2026',
        status: 'Found',
        statusColor: AppColors.secondary,
        icon: Icons.umbrella_rounded,
      ),
      _MockItem(
        title: 'Car Keys (Toyota)',
        location: 'Parking Lot B',
        date: 'Jun 8, 2026',
        status: 'Found',
        statusColor: AppColors.secondary,
        icon: Icons.key_rounded,
      ),
    ];
    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _ItemCard(item: item),
    )).toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Private sub-widgets
// ═══════════════════════════════════════════════════════════════════════════════

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning 👋',
          style: AppTextStyles.headlineLgMobile.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome to CampusTrace',
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Find, report, and recover lost belongings across campus.',
          style: AppTextStyles.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMd.copyWith(fontSize: 18)),
        if (trailing != null)
          GestureDetector(
            onTap: () {},
            child: Text(
              trailing!,
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '1,248',
            label: 'Items Reported',
            icon: Icons.inventory_2_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '906',
            label: 'Recovered',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '72%',
            label: 'Success Rate',
            icon: Icons.trending_up_rounded,
            color: AppColors.primaryContainer,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMd.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mock data model ─────────────────────────────────────────────────────────

class _MockItem {
  final String title;
  final String location;
  final String date;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _MockItem({
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}

class _ItemCard extends StatelessWidget {
  final _MockItem item;

  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item icon placeholder
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.statusColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: item.statusColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onBackground,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        item.location,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.date,
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.outline,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: item.statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.status,
              style: AppTextStyles.labelSm.copyWith(
                color: item.statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
