import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/frontend/screens/report/report_item_screen.dart';
import 'package:campus_trace/frontend/screens/item/item_detail_screen.dart';
import 'package:campus_trace/frontend/screens/notifications/notifications_screen.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'All';
  bool _isLoading = false;
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Lost',
    'Found',
    'Recovered',
    'Archived',
  ];

  List<_MockReportItem> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _reports = [
      _MockReportItem(
        id: '1',
        title: 'Laptop Charger',
        type: 'Lost',
        location: 'Library, 2nd Floor',
        date: 'Oct 24',
        status: 'Active',
        icon: Icons.power_rounded,
      ),
      _MockReportItem(
        id: '2',
        title: 'Student ID',
        type: 'Lost',
        location: 'Science Building',
        date: 'Oct 22',
        status: 'Recovered',
        icon: Icons.badge_rounded,
      ),
      _MockReportItem(
        id: '3',
        title: 'Wallet',
        type: 'Found',
        location: 'Cafeteria',
        date: 'Oct 21',
        status: 'Active',
        icon: Icons.account_balance_wallet_rounded,
      ),
      _MockReportItem(
        id: '4',
        title: 'Keys',
        type: 'Found',
        location: 'Campus Cafe',
        date: 'Oct 20',
        status: 'Archived',
        icon: Icons.key_rounded,
      ),
      _MockReportItem(
        id: '5',
        title: 'Backpack',
        type: 'Lost',
        location: 'Main Entrance',
        date: 'Oct 15',
        status: 'Active',
        icon: Icons.backpack_rounded,
      ),
    ];
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  void _markRecovered(String id) {
    setState(() {
      final index = _reports.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reports[index].status = 'Recovered';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Marked as Recovered!'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _archiveReport(String id) {
    setState(() {
      final index = _reports.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reports[index].status = 'Archived';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Report Archived'),
        backgroundColor: AppColors.onSurfaceVariant,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<_MockReportItem> get _filteredReports {
    return _reports.where((r) {
      final matchesSearch = r.title.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Lost' || _selectedFilter == 'Found') {
        return r.type == _selectedFilter && r.status == 'Active';
      }
      return r.status == _selectedFilter;
    }).toList();
  }

  int get _activeCount => _reports.where((r) => r.status == 'Active').length;
  int get _recoveredCount => _reports.where((r) => r.status == 'Recovered').length;
  int get _archivedCount => _reports.where((r) => r.status == 'Archived').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopSection(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceContainerLowest,
              child: _isLoading ? _buildLoadingState() : _buildListContent(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReportItemScreen()),
          );
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Reports',
            style: AppTextStyles.headlineLgMobile.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Track and manage your submissions',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
          },
          icon: Badge(
            smallSize: 8,
            backgroundColor: AppColors.tertiary,
            child: const Icon(Icons.notifications_outlined),
          ),
          color: AppColors.onSurfaceVariant,
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTopSection() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Active\nReports',
                  value: '$_activeCount',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Recovered\nItems',
                  value: '$_recoveredCount',
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Archived\nReports',
                  value: '$_archivedCount',
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by item name...',
                hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
                border: InputBorder.none,
                icon: const Icon(Icons.search_rounded, color: AppColors.outline, size: 22),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                      _isLoading = true;
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) setState(() => _isLoading = false);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      filter,
                      style: AppTextStyles.labelMd.copyWith(
                        color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListContent() {
    final items = _filteredReports;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ReportCard(
          item: items[index],
          onMarkRecovered: () => _markRecovered(items[index].id),
          onArchive: () => _archiveReport(items[index].id),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    String message = 'No Reports Yet';
    if (_selectedFilter == 'Lost') message = 'No Lost Reports';
    if (_selectedFilter == 'Found') message = 'No Found Reports';
    if (_selectedFilter == 'Recovered') message = 'No Recovered Items';
    if (_selectedFilter == 'Archived') message = 'No Archived Reports';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 300,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: AppColors.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onBackground,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters.',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportItemScreen()),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Create Report'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.labelMd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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

class _MockReportItem {
  final String id;
  final String title;
  final String type;
  final String location;
  final String date;
  String status;
  final IconData icon;

  _MockReportItem({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.date,
    required this.status,
    required this.icon,
  });
}

class _ReportCard extends StatelessWidget {
  final _MockReportItem item;
  final VoidCallback onMarkRecovered;
  final VoidCallback onArchive;

  const _ReportCard({
    required this.item,
    required this.onMarkRecovered,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final isRecovered = item.status == 'Recovered';
    final isArchived = item.status == 'Archived';
    
    // Border accent color based on status
    Color borderColor = AppColors.outlineVariant.withValues(alpha: 0.3);
    if (isRecovered) borderColor = AppColors.secondary.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemDetailScreen(
              isOwner: true,
              title: item.title,
              type: item.type,
              status: item.status,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isRecovered ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: isRecovered 
                ? AppColors.secondary.withValues(alpha: 0.05)
                : AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 32,
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Item Details
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
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusBadge(item.status),
                        ],
                      ),
                      const SizedBox(height: 6),
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
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.date,
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.outline,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.type == 'Lost' 
                                  ? AppColors.error.withValues(alpha: 0.1) 
                                  : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.type,
                              style: AppTextStyles.labelSm.copyWith(
                                color: item.type == 'Lost' ? AppColors.error : AppColors.primary,
                                fontSize: 10,
                              ),
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
          
          // Action Row
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
              color: isRecovered ? AppColors.secondary.withValues(alpha: 0.02) : Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildCompactAction(
                  icon: Icons.edit,
                  label: 'Edit',
                  color: AppColors.primary,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                _buildCompactAction(
                  icon: Icons.archive,
                  label: 'Archive',
                  color: AppColors.onSurfaceVariant,
                  onPressed: isArchived ? null : onArchive,
                ),
                const SizedBox(width: 8),
                _buildCompactAction(
                  icon: Icons.check_circle,
                  label: 'Recovered',
                  color: AppColors.secondary,
                  onPressed: (isRecovered || isArchived) ? null : onMarkRecovered,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCompactAction({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    final bool isDisabled = onPressed == null;
    final Color effectiveColor = isDisabled ? AppColors.outlineVariant : color;
    
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.transparent : effectiveColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDisabled 
                  ? AppColors.outlineVariant.withValues(alpha: 0.3) 
                  : effectiveColor.withValues(alpha: 0.3),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: effectiveColor),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: AppTextStyles.labelSm.copyWith(
                      color: effectiveColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case 'Recovered':
        color = AppColors.secondary;
        icon = Icons.check_circle_rounded;
        break;
      case 'Archived':
        color = AppColors.outline;
        icon = Icons.archive_rounded;
        break;
      default:
        color = AppColors.primaryContainer;
        icon = Icons.radio_button_checked_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppTextStyles.labelSm.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
