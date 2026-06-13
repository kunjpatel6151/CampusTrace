import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/frontend/screens/report/report_item_screen.dart';
import 'package:campus_trace/frontend/screens/item/item_detail_screen.dart';
import 'package:campus_trace/frontend/screens/notifications/notifications_screen.dart';
import 'package:campus_trace/backend/services/report_service.dart';
import 'package:campus_trace/backend/models/report_model.dart';
import 'package:campus_trace/core/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  final ReportService _reportService = ReportService();

  List<String> get _categories => ['All', ...AppConstants.reportCategories];

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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItemsList(isLost: true),
                _buildItemsList(isLost: false),
              ],
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
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase().trim();
          });
        },
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search items, locations, or categories',
          hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.outline,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
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
    return StreamBuilder<List<ReportModel>>(
      stream: _reportService.getAllReports(),
      builder: (context, snapshot) {
        if (_isLoading || snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          debugPrint('DiscoverScreen Stream Error: ${snapshot.error}');
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                '${snapshot.error}',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        List<ReportModel> items = snapshot.data ?? [];
        
        // Filter by Lost/Found
        items = items.where((item) => item.type == (isLost ? 'lost' : 'found')).toList();

        // Filter by Category
        if (_selectedCategory != 'All') {
          items = items.where((item) => item.category == _selectedCategory).toList();
        }

        // Filter by Search Query
        if (_searchQuery.isNotEmpty) {
          items = items.where((item) {
            final titleMatch = item.title.toLowerCase().contains(_searchQuery);
            final descMatch = item.description.toLowerCase().contains(_searchQuery);
            final locMatch = item.location.toLowerCase().contains(_searchQuery);
            final catMatch = item.category.toLowerCase().contains(_searchQuery);
            return titleMatch || descMatch || locMatch || catMatch;
          }).toList();
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
              'No reports available yet.',
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
}

class _DiscoverItemCard extends StatelessWidget {
  final ReportModel item;

  const _DiscoverItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    
    if (item.isRecovered || item.status == 'recovered') {
      statusColor = AppColors.outline;
      statusText = 'Recovered';
    } else {
      statusColor = item.type == 'lost' ? AppColors.tertiary : AppColors.secondary;
      statusText = item.type == 'lost' ? 'Lost' : 'Found';
    }

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
                  report: item,
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
                    image: item.imageUrl.isNotEmpty ? DecorationImage(
                      image: CachedNetworkImageProvider(item.imageUrl),
                      fit: BoxFit.cover,
                    ) : null,
                  ),
                  child: item.imageUrl.isEmpty ? Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: AppColors.outlineVariant,
                    ),
                  ) : null,
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
                                DateFormat('MMM d').format(item.reportDate),
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
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  statusText,
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: statusColor,
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
