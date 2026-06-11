import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';

class ItemDetailScreen extends StatefulWidget {
  final bool isOwner;
  final String title;
  final String type; // 'Lost' or 'Found'
  final String status; // 'Active', 'Recovered', 'Archived'

  const ItemDetailScreen({
    super.key,
    this.isOwner = false,
    this.title = 'Matte Black Leather Wallet',
    this.type = 'Lost',
    this.status = 'Active',
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  // Mock data
  final String _date = 'Reported 2 hours ago';
  final String _summary = 'Lost near the main campus library entrance. Contains important ID cards.';
  final String _category = 'Accessories';
  final String _location = 'Engineering Library';
  final String _reportId = '#CT-8924A';
  final String _description = 'I believe it fell out of my coat pocket while I was walking up the main steps to the engineering library around 10:30 AM this morning.\n\nThe wallet is relatively slim, matte black leather, and has a distinctive blue stitching on the inside fold. It contains my student ID, a driver\'s license, and two credit cards. If found, please handle with care as the IDs are urgently needed for finals week.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100), // padding for bottom bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      _buildKeyInfoSection(),
                      _buildDescriptionSection(),
                      _buildLocationSection(),
                      _buildReporterSection(),
                      _buildSimilarItemsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onBackground),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Item Details',
        style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded, color: AppColors.onBackground),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Mock image container
            Hero(
              tag: 'item_image_${widget.title}',
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                ),
                child: Center(
                  child: Icon(
                    Icons.image_rounded,
                    size: 80,
                    color: AppColors.outlineVariant,
                  ),
                ),
              ),
            ),
            // Gradient Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.background,
                      AppColors.background.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Image Indicator
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '1 / 3',
                  style: AppTextStyles.labelSm.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    Color badgeColor;
    if (widget.status == 'Recovered') {
      badgeColor = AppColors.secondary;
    } else if (widget.type == 'Lost') {
      badgeColor = AppColors.error;
    } else {
      badgeColor = AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.status == 'Recovered' ? 'RECOVERED' : widget.type.toUpperCase(),
                      style: AppTextStyles.labelSm.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _date,
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.onBackground),
          ),
          const SizedBox(height: 8),
          Text(
            _summary,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: [
          _buildInfoCard('Category', _category, Icons.category_outlined),
          _buildInfoCard('Location', _location, Icons.location_on_outlined),
          _buildInfoCard('Date', 'Oct 24, 2026', Icons.calendar_today_outlined),
          _buildInfoCard('Report ID', _reportId, Icons.tag_rounded),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.outline,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.onBackground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Description',
                  style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _description,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Seen Location',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.onBackground),
          ),
          const SizedBox(height: 12),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.map_outlined, size: 48, color: AppColors.outlineVariant),
                ),
                Center(
                  child: Icon(Icons.location_on_rounded, size: 32, color: AppColors.primary),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      _location,
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.onBackground),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReporterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Center(
                child: Text(
                  'KP',
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Kunj Patel',
                        style: AppTextStyles.labelMd.copyWith(color: AppColors.onBackground, fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.verified_rounded, size: 14, color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Verified Campus User',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarItemsSection() {
    final mockSimilar = ['Wallet', 'Student ID', 'Backpack', 'Keys'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Similar Reports',
            style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground, fontSize: 18),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: mockSimilar.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, color: AppColors.outlineVariant, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      mockSimilar[index],
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.onBackground),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.9),
          border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: widget.isOwner ? _buildOwnerActions() : _buildViewerAction(),
      ),
    );
  }

  Widget _buildViewerAction() {
    final btnText = widget.type == 'Lost' ? 'Contact Finder' : 'Contact Reporter';
    return ElevatedButton.icon(
      onPressed: () => _showContactBottomSheet(),
      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
      label: Text(
        btnText,
        style: AppTextStyles.labelMd.copyWith(color: Colors.white, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    );
  }

  Widget _buildOwnerActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Report'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
            label: const Text('Mark Recovered'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  void _showContactBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Contact Reporter',
                  style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how you would like to connect.',
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                _ContactOptionTile(
                  icon: Icons.phone_outlined,
                  title: 'Call',
                  subtitle: '+1 (555) 000-0000',
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                _ContactOptionTile(
                  icon: Icons.mail_outline,
                  title: 'Email',
                  subtitle: 'reporter@campus.edu',
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 12),
                _ContactOptionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'In-App Message',
                  subtitle: 'Instant messaging',
                  color: AppColors.tertiary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContactOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ContactOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
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
