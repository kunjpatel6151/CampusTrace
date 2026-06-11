import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/frontend/screens/report/report_item_screen.dart';
import 'package:campus_trace/frontend/screens/item/item_detail_screen.dart';
import 'package:campus_trace/frontend/screens/notifications/notifications_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'Electronics',
    'Wallets',
    'IDs',
    'Bags',
    'Keys',
    'Books',
    'Bottles',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    setState(() {}); // Trigger rebuild for active tab styling if needed
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    // Mock network delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search and Filters Section
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildCategoryChips(),
                const SizedBox(height: 16),
                _buildToggle(),
              ],
            ),
          ),
          
          // List Section
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceContainerLowest,
              child: _isLoading 
                ? _buildLoadingState()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildItemsList(isLost: true),
                      _buildItemsList(isLost: false),
                    ],
                  ),
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
            'Discover',
            style: AppTextStyles.headlineLgMobile.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Browse lost and found reports',
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.outline,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search items, locations, or categories',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.outline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _isLoading = true;
              });
              // Simulate loading when category changes
              Future.delayed(const Duration(milliseconds: 500), () {
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
                category,
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        labelStyle: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Lost Items'),
          Tab(text: 'Found Items'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _ShimmerContainer(width: 80, height: 80, borderRadius: 12),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ShimmerContainer(width: double.infinity, height: 16, borderRadius: 4),
                      const SizedBox(height: 12),
                      _ShimmerContainer(width: 120, height: 12, borderRadius: 4),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ShimmerContainer(width: 80, height: 20, borderRadius: 10),
                          _ShimmerContainer(width: 60, height: 12, borderRadius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsList({required bool isLost}) {
    List<_DiscoverMockItem> items = isLost ? _getMockLostItems() : _getMockFoundItems();
    
    // Simple mock filter
    if (_selectedCategory != 'All') {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }

    if (items.isEmpty) {
      return _buildEmptyState(isLost: isLost);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _DiscoverItemCard(item: items[index]);
      },
    );
  }

  Widget _buildEmptyState({required bool isLost}) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 400,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLost ? Icons.search_off_rounded : Icons.inbox_outlined,
              size: 64,
              color: AppColors.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isLost ? 'No lost items found' : 'No matching results',
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
                setState(() {
                  _selectedCategory = 'All';
                });
              },
              icon: const Icon(Icons.clear_all_rounded, size: 20),
              label: const Text('Clear Filters'),
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

  List<_DiscoverMockItem> _getMockLostItems() {
    return [
      _DiscoverMockItem(
        title: 'Laptop Charger (Type-C)',
        location: 'Library, 2nd Floor',
        date: '2 hours ago',
        category: 'Electronics',
        status: 'Lost',
        statusColor: AppColors.tertiary,
        icon: Icons.power_rounded,
      ),
      _DiscoverMockItem(
        title: 'Student ID Card',
        location: 'Science Building',
        date: 'Today',
        category: 'IDs',
        status: 'Lost',
        statusColor: AppColors.tertiary,
        icon: Icons.badge_rounded,
      ),
      _DiscoverMockItem(
        title: 'Black Leather Wallet',
        location: 'Cafeteria',
        date: 'Yesterday',
        category: 'Wallets',
        status: 'Lost',
        statusColor: AppColors.tertiary,
        icon: Icons.account_balance_wallet_rounded,
      ),
      _DiscoverMockItem(
        title: 'AirPods Pro Right Earbud',
        location: 'Gym',
        date: 'Jun 8',
        category: 'Electronics',
        status: 'Lost',
        statusColor: AppColors.tertiary,
        icon: Icons.headphones_rounded,
      ),
    ];
  }

  List<_DiscoverMockItem> _getMockFoundItems() {
    return [
      _DiscoverMockItem(
        title: 'Hydro Flask (Blue)',
        location: 'Gym Locker Room',
        date: '1 hour ago',
        category: 'Bottles',
        status: 'Found',
        statusColor: AppColors.secondary,
        icon: Icons.water_drop_rounded,
      ),
      _DiscoverMockItem(
        title: 'TI-84 Calculator',
        location: 'Math Lab 101',
        date: 'Today',
        category: 'Electronics',
        status: 'Found',
        statusColor: AppColors.secondary,
        icon: Icons.calculate_rounded,
      ),
      _DiscoverMockItem(
        title: 'Car Keys (Toyota)',
        location: 'Parking Lot B',
        date: 'Yesterday',
        category: 'Keys',
        status: 'Claimed',
        statusColor: AppColors.outline,
        icon: Icons.key_rounded,
      ),
      _DiscoverMockItem(
        title: 'North Face Backpack',
        location: 'Main Entrance',
        date: 'Jun 8',
        category: 'Bags',
        status: 'Found',
        statusColor: AppColors.secondary,
        icon: Icons.backpack_rounded,
      ),
    ];
  }
}

class _DiscoverMockItem {
  final String title;
  final String location;
  final String date;
  final String category;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _DiscoverMockItem({
    required this.title,
    required this.location,
    required this.date,
    required this.category,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}

class _DiscoverItemCard extends StatelessWidget {
  final _DiscoverMockItem item;

  const _DiscoverItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ItemDetailScreen(
                  isOwner: false,
                  title: item.title,
                  type: item.statusColor == AppColors.error ? 'Lost' : 'Found',
                  status: 'Active',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 40,
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
                      Text(
                        item.title,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.onBackground,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Category Chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          
                          // Date & Status
                          Row(
                            children: [
                              Text(
                                item.date,
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.outline,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.status,
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: item.statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
}

class _ShimmerContainer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerContainer({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<_ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<_ShimmerContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _colorAnimation = ColorTween(
      begin: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
      end: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
