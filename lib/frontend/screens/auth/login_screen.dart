// login_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/frontend/widgets/auth_card.dart';
import 'package:campus_trace/frontend/widgets/custom_text_field.dart';
import 'package:campus_trace/frontend/widgets/custom_password_field.dart';
import 'package:campus_trace/frontend/widgets/primary_button.dart';
import 'package:campus_trace/frontend/widgets/app_brand_logo.dart';
import 'package:campus_trace/frontend/screens/auth/signup_screen.dart';
import 'package:campus_trace/frontend/screens/home/main_shell_screen.dart';
import 'package:campus_trace/core/constants/app_strings.dart';
import 'package:campus_trace/core/utils/validators.dart';
import 'dart:ui';

/// Login screen for CampusTrace.
///
/// Matches the indigo-purple gradient background from the splash screen,
/// with a centered glassmorphic auth card containing email/password fields,
/// Remember Me, Forgot Password, and a Sign Up link.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    // TEMPORARY: Skip validation and navigate directly to dashboard.
    // Will be replaced with Firebase Auth integration later.
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const MainShellScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const SignupScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
      ),
    );
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
                                  // Welcome heading
                                  Text(
                                    AppStrings.welcomeBack,
                                    style:
                                        AppTextStyles.headlineLgMobile.copyWith(
                                      color: AppColors.onBackground,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    AppStrings.loginSubtitle,
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Email
                                  CustomTextField(
                                    label: AppStrings.campusEmail,
                                    hint: AppStrings.emailHint,
                                    icon: Icons.mail_outline_rounded,
                                    controller: _emailController,
                                    validator: Validators.email,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),

                                  // Password
                                  CustomPasswordField(
                                    label: AppStrings.password,
                                    hint: AppStrings.passwordHint,
                                    controller: _passwordController,
                                    validator: Validators.password,
                                    textInputAction: TextInputAction.done,
                                  ),
                                  const SizedBox(height: 12),

                                  // Remember Me + Forgot Password row
                                  Row(
                                    children: [
                                      // Remember Me
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (v) => setState(
                                              () => _rememberMe = v ?? false),
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
                                      Text(
                                        AppStrings.rememberMe,
                                        style: AppTextStyles.bodySm.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Forgot Password
                                      GestureDetector(
                                        onTap: () {
                                          // TODO: Navigate to Forgot Password
                                        },
                                        child: Text(
                                          AppStrings.forgotPassword,
                                          style:
                                              AppTextStyles.labelSm.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),

                                  // Sign In button
                                  PrimaryButton(
                                    label: AppStrings.signIn,
                                    onPressed: _handleSignIn,
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
                                AppStrings.noAccount,
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToSignup,
                                child: Text(
                                  AppStrings.signUp,
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
        // Logo
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
// Shared background widget for auth screens
// ═══════════════════════════════════════════════════════════════════════════════

/// Soft indigo-purple gradient blobs for auth screen backgrounds.
/// Intentionally matches the splash screen aesthetic.
class _AuthBackgroundBlobs extends StatelessWidget {
  final Size screenSize;

  const _AuthBackgroundBlobs({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Upper-left indigo blob
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
            // Lower-right teal blob
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
