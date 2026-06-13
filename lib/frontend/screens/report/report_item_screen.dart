import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/backend/services/auth_service.dart';
import 'package:campus_trace/backend/services/cloudinary_service.dart';
import 'package:campus_trace/backend/services/report_service.dart';
import 'package:campus_trace/backend/models/report_model.dart';
import 'package:campus_trace/core/constants/app_constants.dart';

class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  bool _isLostItem = true;
  File? _selectedPhoto;
  String _selectedCategory = AppConstants.reportCategories.first;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // We use a controller for Date to show "Today" as default in UI
  final TextEditingController _dateController = TextEditingController(text: 'Today');
  
  bool _isLoading = false;
  DateTime _actualSelectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedPhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImagePicker() {
    // Image selection
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Upload Photo',
                  style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                  ),
                  title: Text('Take Photo', style: AppTextStyles.bodyMd),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: Icon(Icons.photo_library_rounded, color: AppColors.primary),
                  ),
                  title: Text('Choose from Gallery', style: AppTextStyles.bodyMd),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = initialDate.subtract(const Duration(days: 180));
    final DateTime lastDate = initialDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surfaceContainerLowest,
              onSurface: AppColors.onBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _actualSelectedDate = pickedDate;
        _dateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _validateAndSubmit() async {
    if (_nameController.text.trim().isEmpty || 
        _locationController.text.trim().isEmpty ||
        _dateController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill out all required fields.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please attach a photo of the item.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final user = authService.currentUser;
      if (user == null) throw Exception('User not authenticated.');

      final userData = await authService.getUserData(user.uid);
      if (userData == null) throw Exception('User data not found.');

      final cloudinaryService = CloudinaryService();
      final imageUrl = await cloudinaryService.uploadImage(_selectedPhoto!);
      
      if (imageUrl == null) {
        throw Exception('Image upload failed.');
      }

      final reportService = ReportService();
      final report = ReportModel(
        reportId: '', // Service will generate this
        userId: user.uid,
        userName: userData.fullName,
        userEmail: userData.email,
        type: _isLostItem ? 'lost' : 'found',
        title: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        location: _locationController.text.trim(),
        reportDate: _actualSelectedDate,
        imageUrl: imageUrl,
        status: 'active',
        isRecovered: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await reportService.createReport(report);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report published successfully.'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120), // Bottom padding for sticky action bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Report Type', required: true),
                const SizedBox(height: 12),
                _buildSegmentedToggle(),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Photo Evidence', required: true),
                const SizedBox(height: 12),
                _buildPhotoHeroSection(),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Item Details', required: true),
                const SizedBox(height: 12),
                _buildItemDetailsForm(),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Report Summary'),
                const SizedBox(height: 12),
                _buildPreviewSection(),
              ],
            ),
          ),
          
          // Sticky Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStickyBottomActionBar(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onBackground),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        children: [
          Text(
            'Report Item',
            style: AppTextStyles.headlineMd.copyWith(color: AppColors.onBackground),
          ),
          Text(
            'Help the community recover lost belongings.',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool required = false}) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.outline,
            letterSpacing: 1.2,
          ),
        ),
        if (required)
          Text(
            ' *',
            style: AppTextStyles.labelSm.copyWith(color: AppColors.error),
          ),
      ],
    );
  }

  Widget _buildSegmentedToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption(
              title: 'Lost Item',
              icon: Icons.search_off_rounded,
              isActive: _isLostItem,
              activeColor: AppColors.error,
              onTap: () => setState(() => _isLostItem = true),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildToggleOption(
              title: 'Found Item',
              icon: Icons.task_alt_rounded,
              isActive: !_isLostItem,
              activeColor: AppColors.secondary,
              onTap: () => setState(() => _isLostItem = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor.withValues(alpha: 0.2) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? activeColor : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.labelMd.copyWith(
                color: isActive ? activeColor : AppColors.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoHeroSection() {
    if (_selectedPhoto != null) {
      // Preview State
      return AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            image: DecorationImage(
              image: FileImage(_selectedPhoto!),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPhotoActionButton(
                      icon: Icons.sync_rounded,
                      label: 'Replace Photo',
                      onTap: _showImagePicker,
                    ),
                    const SizedBox(width: 16),
                    _buildPhotoActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Remove',
                      isDestructive: true,
                      onTap: () => setState(() => _selectedPhoto = null),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Upload State
    return GestureDetector(
      onTap: _showImagePicker,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.outlineVariant,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tap to Capture or Upload',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.onBackground),
              ),
              const SizedBox(height: 8),
              Text(
                'Clear photos help with quicker recovery.',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.errorContainer : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDestructive ? AppColors.onErrorContainer : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(
                color: isDestructive ? AppColors.onErrorContainer : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Name
          _buildFormFieldLabel('Item Name'),
          _buildTextField(
            controller: _nameController,
            hintText: 'e.g. MacBook Pro, Blue Hydroflask',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),

          // Category
          _buildFormFieldLabel('Category'),
          _buildCategoryPicker(),
          const SizedBox(height: 20),

          // Location
          _buildFormFieldLabel('Last Seen Location'),
          _buildTextField(
            controller: _locationController,
            hintText: 'Where was the item lost or found?',
            icon: Icons.location_on_outlined,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),

          // Date
          _buildFormFieldLabel('Date'),
          _buildTextField(
            controller: _dateController,
            hintText: 'Select date',
            icon: Icons.calendar_today_outlined,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 20),

          // Description
          _buildFormFieldLabel('Detailed Description'),
          _buildTextField(
            controller: _descriptionController,
            hintText: 'Mention unique identifiers, colors, stickers, scratches, serial numbers, etc.',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildFormFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: AppTextStyles.bodyMd.copyWith(color: AppColors.onBackground),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.outline, size: 22) : null,
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 16 : 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.reportCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = AppConstants.reportCategories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
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

  Widget _buildPreviewSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mock Image Preview
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              image: _selectedPhoto != null ? DecorationImage(
                image: FileImage(_selectedPhoto!),
                fit: BoxFit.cover,
              ) : null,
            ),
            child: _selectedPhoto == null ? Icon(Icons.image_not_supported_outlined, color: AppColors.outline) : null,
          ),
          const SizedBox(width: 16),
          // Preview Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isLostItem 
                          ? AppColors.error.withValues(alpha: 0.1) 
                          : AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _isLostItem ? 'Lost' : 'Found',
                        style: AppTextStyles.labelSm.copyWith(
                          color: _isLostItem ? AppColors.error : AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedCategory,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _nameController.text.isEmpty ? 'Item Name' : _nameController.text,
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.onBackground, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: AppColors.outline),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _locationController.text.isEmpty ? 'Location' : _locationController.text,
                        style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), // Include safe area basically
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _validateAndSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading 
                ? const SizedBox(
                    width: 24, 
                    height: 24, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text('Publish Report', style: AppTextStyles.labelMd.copyWith(color: Colors.white, fontSize: 16)),
                    ],
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You can edit your report later.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
