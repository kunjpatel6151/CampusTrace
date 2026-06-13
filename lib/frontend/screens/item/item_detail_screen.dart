import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/backend/models/report_model.dart';
import 'package:campus_trace/backend/services/auth_service.dart';
import 'package:campus_trace/backend/services/report_service.dart';
import 'package:campus_trace/backend/models/app_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailScreen extends StatefulWidget {
  final ReportModel? report;

  const ItemDetailScreen({
    super.key,
    this.report,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final AuthService _authService = AuthService();
  final ReportService _reportService = ReportService();
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _isOwner = _authService.currentUser?.uid == widget.report?.userId;
  }

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
              tag: 'item_image_${widget.report?.reportId ?? 'new'}',
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  image: widget.report != null && widget.report!.imageUrl.isNotEmpty ? DecorationImage(
                    image: CachedNetworkImageProvider(widget.report!.imageUrl),
                    fit: BoxFit.cover,
                  ) : null,
                ),
                child: widget.report == null || widget.report!.imageUrl.isEmpty ? Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 80,
                    color: AppColors.outlineVariant,
                  ),
                ) : null,
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    if (widget.report == null) return const SizedBox.shrink();
    
    final isRecovered = widget.report!.isRecovered || widget.report!.status == 'recovered';
    final type = widget.report!.type;
    
    Color badgeColor;
    if (isRecovered) {
      badgeColor = AppColors.secondary;
    } else if (type == 'lost') {
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
                      isRecovered ? 'RECOVERED' : type.toUpperCase(),
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
                'Reported on ${DateFormat('MMM d, yyyy').format(widget.report!.reportDate)}',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.report!.title,
            style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.onBackground),
          ),
          const SizedBox(height: 8),
          // We don't have a separate summary, description can serve this locally if needed
          // Or we can just omit summary since it's redundant with description
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
          _buildInfoCard('Category', widget.report?.category ?? '', Icons.category_outlined),
          _buildInfoCard('Location', widget.report?.location ?? '', Icons.location_on_outlined),
          _buildInfoCard('Date', widget.report != null ? DateFormat('MMM d, yyyy').format(widget.report!.reportDate) : '', Icons.calendar_today_outlined),
          _buildInfoCard('Report ID', widget.report?.reportId.substring(0, 8).toUpperCase() ?? '', Icons.tag_rounded),
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
              widget.report?.description ?? '',
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
                      widget.report?.location ?? '',
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
                  widget.report?.userName.isNotEmpty == true ? widget.report!.userName[0].toUpperCase() : 'U',
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
                        widget.report?.userName ?? 'User',
                        style: AppTextStyles.labelMd.copyWith(color: AppColors.onBackground, fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.verified_rounded, size: 14, color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.report?.userEmail ?? '',
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
        child: _isOwner ? _buildOwnerActions() : _buildViewerAction(),
      ),
    );
  }

  Widget _buildViewerAction() {
    final btnText = widget.report?.type == 'lost' ? 'Contact Finder' : 'Contact Reporter';
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
    final isRecovered = widget.report?.isRecovered == true || widget.report?.status == 'recovered';
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Edit not fully specified yet, placeholder
            },
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
            onPressed: isRecovered ? null : () async {
              try {
                await _reportService.markRecovered(widget.report!.reportId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Marked as Recovered!'),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
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
          child: FutureBuilder<AppUser?>(
            future: _authService.getUserData(widget.report?.userId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final user = snapshot.data;
              final hasPhone = user != null && user.phoneNumber != null && user.phoneNumber!.isNotEmpty;
              final hasEmail = user != null && user.email.isNotEmpty;

              return Padding(
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
                      subtitle: hasPhone ? user.phoneNumber! : 'Phone number not available',
                      color: hasPhone ? AppColors.primary : AppColors.outlineVariant,
                      onTap: hasPhone ? () {
                        Navigator.pop(context);
                        launchUrl(Uri.parse('tel:${user.phoneNumber}'));
                      } : null,
                    ),
                    const SizedBox(height: 12),
                    _ContactOptionTile(
                      icon: Icons.mail_outline,
                      title: 'Email',
                      subtitle: hasEmail ? user.email : 'Email not available',
                      color: hasEmail ? AppColors.secondary : AppColors.outlineVariant,
                      onTap: hasEmail ? () {
                        Navigator.pop(context);
                        launchUrl(Uri.parse('mailto:${user.email}'));
                      } : null,
                    ),
                  ],
                ),
              );
            },
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
  final VoidCallback? onTap;

  const _ContactOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
