// splash_loading_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/theme/app_text_styles.dart';
import 'package:campus_trace/frontend/widgets/animated_logo.dart';
import 'package:campus_trace/frontend/widgets/animated_loading_bar.dart';
import 'package:campus_trace/frontend/screens/auth/login_screen.dart';

/// Full-screen splash / loading screen for CampusTrace.
///
/// Layout:
///  • Soft off-white background with two large, blurred gradient blobs
///    (indigo/purple upper-left, green/teal lower-right) at very low opacity.
///  • Main content (logo + title + subtitle) is vertically & horizontally
///    centered.
///  • A loading bar with status text is pinned near the bottom.
///
/// After approximately 2.5 seconds, automatically navigates to [LoginScreen]
/// with a smooth fade transition.
class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for splash content
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentFade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _fadeController.forward();

    // Auto-navigate after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _contentFade,
        child: Stack(
          children: [
            // ── Background blobs ─────────────────────────────────────────────
            _BackgroundBlobs(screenSize: size),

            // ── Centered content ─────────────────────────────────────────────
            const Center(
              child: _CenterContent(),
            ),

            // ── Bottom loading area ──────────────────────────────────────────
            const Positioned(
              left: 0,
              right: 0,
              bottom: 64,
              child: _BottomLoadingSection(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Private sub-widgets
// ═══════════════════════════════════════════════════════════════════════════════

/// Two large, extremely-low-opacity blurred blobs that add a soft gradient feel
/// to the background.
class _BackgroundBlobs extends StatelessWidget {
  final Size screenSize;

  const _BackgroundBlobs({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Upper-left indigo / purple blob
            Positioned(
              top: screenSize.height * 0.25,
              left: -screenSize.width * 0.25,
              width: screenSize.width * 1.5,
              height: screenSize.height * 1.5,
              child: _BlurredBlob(
                color: AppColors.primaryContainer.withValues(alpha: 0.05),
                blurSigma: 120,
              ),
            ),
            // Lower-right green / teal blob
            Positioned(
              bottom: screenSize.height * 0.25,
              right: -screenSize.width * 0.25,
              width: screenSize.width,
              height: screenSize.height,
              child: _BlurredBlob(
                color: AppColors.secondaryContainer.withValues(alpha: 0.05),
                blurSigma: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single large circular blob rendered with [ImageFilter.blur].
class _BlurredBlob extends StatelessWidget {
  final Color color;
  final double blurSigma;

  const _BlurredBlob({
    required this.color,
    required this.blurSigma,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurSigma,
        sigmaY: blurSigma,
        tileMode: TileMode.decal,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

/// The vertically-centered content block: animated logo, title, and subtitle.
class _CenterContent extends StatelessWidget {
  const _CenterContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo with pulse-glow animation
        const AnimatedLogo(size: 140),
        const SizedBox(height: 32),

        // App name
        Text(
          'CampusTrace',
          style: AppTextStyles.headlineXl.copyWith(
            fontSize: 38,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 16),

        // Subtitle
        SizedBox(
          width: 280,
          child: Text(
            'Intelligent item recovery for modern campuses.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.80),
            ),
          ),
        ),
      ],
    );
  }
}

/// The bottom-pinned loading indicator and status label.
class _BottomLoadingSection extends StatelessWidget {
  const _BottomLoadingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated loading bar
        const AnimatedLoadingBar(width: 280, height: 4),
        const SizedBox(height: 12),

        // Status text
        Text(
          'INITIALIZING SYSTEM...',
          style: AppTextStyles.labelSm.copyWith(
            letterSpacing: 2.4,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}
