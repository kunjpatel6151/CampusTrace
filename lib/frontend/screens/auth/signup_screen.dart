// signup_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/frontend/widgets/auth_card.dart';
import 'package:campus_trace/frontend/widgets/custom_text_field.dart';
import 'package:campus_trace/frontend/widgets/custom_password_field.dart';
import 'package:campus_trace/frontend/widgets/primary_button.dart';
import 'package:campus_trace/frontend/widgets/app_brand_logo.dart';
import 'package:campus_trace/core/constants/app_strings.dart';
import 'package:campus_trace/core/utils/validators.dart';
import 'dart:ui';

/// Signup screen for CampusTrace.
///
/// Visually consistent with [LoginScreen]: same background blobs,
/// same auth card styling, shared widgets. Adds fields for full name,
/// phone number, and confirm password, plus a Terms & Conditions checkbox.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the Terms & Conditions.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Integrate Firebase Auth
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account creation not yet connected.'),
          backgroundColor: AppColors.primaryContainer,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background blobs ──────────────────────────────────────────
          _AuthBackgroundBlobs(screenSize: size),

          // ── Scrollable content ────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 32),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Logo + Title ──────────────────────────
                          _buildHeader(),
                          const SizedBox(height: 32),

                          // ── Auth card ────────────────────────────
                          AuthCard(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Heading
                                  Text(
                                    AppStrings.createAccount,
                                    style:
                                        AppTextStyles.headlineLgMobile.copyWith(
                                      color: AppColors.onBackground,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    AppStrings.signupSubtitle,
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Full Name
                                  CustomTextField(
                                    label: AppStrings.fullName,
                                    hint: AppStrings.fullNameHint,
                                    icon: Icons.person_outline_rounded,
                                    controller: _nameController,
                                    validator: Validators.fullName,
                                  ),
                                  const SizedBox(height: 18),

                                  // Campus Email
                                  CustomTextField(
                                    label: AppStrings.campusEmail,
                                    hint: AppStrings.emailHint,
                                    icon: Icons.mail_outline_rounded,
                                    controller: _emailController,
                                    validator: Validators.email,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 18),

                                  // Phone Number
                                  CustomTextField(
                                    label: AppStrings.phoneNumber,
                                    hint: AppStrings.phoneHint,
                                    icon: Icons.phone_outlined,
                                    controller: _phoneController,
                                    validator: Validators.phone,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 18),

                                  // Password
                                  CustomPasswordField(
                                    label: AppStrings.password,
                                    hint: AppStrings.passwordHint,
                                    controller: _passwordController,
                                    validator: Validators.password,
                                  ),
                                  const SizedBox(height: 18),

                                  // Confirm Password
                                  CustomPasswordField(
                                    label: AppStrings.confirmPassword,
                                    hint: AppStrings.passwordHint,
                                    controller: _confirmPasswordController,
                                    validator: Validators.confirmPassword(
                                        _passwordController.text),
                                    textInputAction: TextInputAction.done,
                                  ),
                                  const SizedBox(height: 16),

                                  // Terms & Conditions
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _acceptedTerms,
                                          onChanged: (v) => setState(
                                              () => _acceptedTerms = v ?? false),
                                          activeColor:
                                              AppColors.primaryContainer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          side: BorderSide(
                                            color: AppColors.outlineVariant,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: RichText(
                                          text: TextSpan(
                                            text: AppStrings.termsPrefix,
                                            style:
                                                AppTextStyles.bodySm.copyWith(
                                              color:
                                                  AppColors.onSurfaceVariant,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: AppStrings.termsLink,
                                                style: AppTextStyles.labelMd
                                                    .copyWith(
                                                  color: AppColors.primary,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Create Account button
                                  PrimaryButton(
                                    label: AppStrings.createAccount,
                                    onPressed: _handleCreateAccount,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Bottom link ──────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.hasAccount,
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToLogin,
                                child: Text(
                                  AppStrings.signIn,
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerLowest,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.25),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: AppBrandLogo.custom(dimension: 48),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.appName,
          style: AppTextStyles.headlineLg.copyWith(
            color: AppColors.primary,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Shared background widget (identical to login)
// ═══════════════════════════════════════════════════════════════════════════════

class _AuthBackgroundBlobs extends StatelessWidget {
  final Size screenSize;

  const _AuthBackgroundBlobs({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: -screenSize.height * 0.15,
              left: -screenSize.width * 0.3,
              width: screenSize.width * 1.2,
              height: screenSize.height * 0.8,
              child: _Blob(
                color: AppColors.primaryContainer.withValues(alpha: 0.06),
                blurSigma: 100,
              ),
            ),
            Positioned(
              bottom: -screenSize.height * 0.1,
              right: -screenSize.width * 0.2,
              width: screenSize.width * 0.9,
              height: screenSize.height * 0.7,
              child: _Blob(
                color: AppColors.secondaryContainer.withValues(alpha: 0.05),
                blurSigma: 90,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double blurSigma;

  const _Blob({required this.color, required this.blurSigma});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurSigma,
        sigmaY: blurSigma,
        tileMode: TileMode.decal,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: const SizedBox.expand(),
      ),
    );
  }
}
