import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  bool _isLoading = false;

  final List<String> _filters = ['All', 'Matches', 'Messages', 'Reports', 'System'];

  final List<_NotificationMock> _notifications = [
    _NotificationMock(
      id: '1',
      type: 'Matches',
      title: 'Possible Match Found',
      description: 'A black leather wallet was reported near Engineering Library.',
      timestamp: 'Just now',
      isUnread: true,
      icon: Icons.search_rounded,
      color: AppColors.secondary,
      group: 'Today',
      actionLabel: 'View Item',
    ),
    _NotificationMock(
      id: '2',
      type: 'Messages',
      title: 'New Contact Request',
      description: 'Someone wants to discuss your lost Student ID.',
      timestamp: '2 hours ago',
      isUnread: true,
      icon: Icons.chat_bubble_outline_rounded,
      color: AppColors.primary,
      group: 'Today',
      actionLabel: 'Reply',
    ),
    _NotificationMock(
      id: '3',
      type: 'Reports',
      title: 'Report Marked Recovered',
      description: 'Your Backpack report has been successfully resolved.',
      timestamp: 'Yesterday',
      isUnread: false,
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.secondary,
      group: 'Yesterday',
      actionLabel: 'View Report',
    ),
    _NotificationMock(
      id: '4',
      type: 'System',
      title: 'Welcome to CampusTrace',
      description: 'Start by reporting a lost or found item.',
      timestamp: 'Oct 24',
      isUnread: false,
      icon: Icons.waving_hand_rounded,
      color: AppColors.tertiary,
      group: 'Earlier',
    ),
  ];

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n.isUnread = false;
      }
    });
  }

  void _dismissNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<_NotificationMock> filteredList = _selectedFilter == 'All'
        ? _notifications
        : _notifications.where((n) => n.type == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _unreadCount > 0 ? 'Notifications ($_unreadCount)' : 'Notifications',
          style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllRead,
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Mark All Read'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.labelSm,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceContainerLowest,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                      ? _buildEmptyState()
                      : _buildGroupedList(filteredList),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (val) {
              setState(() => _selectedFilter = filter);
            },
            showCheckmark: false,
            backgroundColor: AppColors.surfaceContainerHigh,
            selectedColor: AppColors.primaryContainer,
            labelStyle: AppTextStyles.labelMd.copyWith(
              color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? Colors.transparent : AppColors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupedList(List<_NotificationMock> list) {
    // Grouping manually for mock layout
    final Map<String, List<_NotificationMock>> grouped = {};
    for (var n in list) {
      grouped.putIfAbsent(n.group, () => []).add(n);
    }

    final groups = ['Today', 'Yesterday', 'Earlier'];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];
        final groupItems = grouped[group] ?? [];
        
        if (groupItems.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
              child: Text(
                group,
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.outline,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ...groupItems.map((item) => _buildNotificationCard(item)),
          ],
        );
      },
    );
  }

  Widget _buildNotificationCard(_NotificationMock item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _dismissNotification(item.id),
        background: Container(
          decoration: BoxDecoration(
            color: AppColors.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: Icon(Icons.delete_outline_rounded, color: AppColors.onErrorContainer),
        ),
        child: GestureDetector(
          onLongPress: () => _showOptionsBottomSheet(item),
          onTap: () {
            if (item.isUnread) {
              setState(() => item.isUnread = false);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.isUnread 
                  ? item.color.withValues(alpha: 0.05) 
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.isUnread
                    ? item.color.withValues(alpha: 0.3)
                    : AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.onBackground,
                                fontWeight: item.isUnread ? FontWeight.w700 : FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (item.isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: AppTextStyles.bodySm.copyWith(
                          color: item.isUnread ? AppColors.onBackground : AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.timestamp,
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.outline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (item.actionLabel != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.actionLabel!,
                                style: AppTextStyles.labelSm.copyWith(color: AppColors.onPrimaryContainer),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(_NotificationMock item) {
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
                if (item.isUnread)
                  ListTile(
                    leading: const Icon(Icons.mark_email_read_outlined, color: AppColors.onSurfaceVariant),
                    title: const Text('Mark as Read'),
                    onTap: () {
                      setState(() => item.isUnread = false);
                      Navigator.pop(context);
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.notifications_off_outlined, color: AppColors.onSurfaceVariant),
                  title: const Text('Mute Similar Notifications'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                  title: Text('Delete Notification', style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    _dismissNotification(item.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 500,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                size: 64,
                color: AppColors.outlineVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications Yet',
              style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
            ),
            const SizedBox(height: 12),
            Text(
              'We\'ll notify you when there is activity related to your reports or items you\'ve found.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationMock {
  final String id;
  final String type;
  final String title;
  final String description;
  final String timestamp;
  bool isUnread;
  final IconData icon;
  final Color color;
  final String group;
  final String? actionLabel;

  _NotificationMock({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isUnread,
    required this.icon,
    required this.color,
    required this.group,
    this.actionLabel,
  });
}
