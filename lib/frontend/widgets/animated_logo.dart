// animated_logo.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';
import 'package:campus_trace/frontend/widgets/app_brand_logo.dart';

/// A circular logo container with an infinite pulsing glow animation.
///
/// The glow oscillates between a subtle and a prominent box-shadow around
/// the logo, using [AppColors.primaryContainer] as the glow color.
///
/// Usage:
/// ```dart
/// const AnimatedLogo(size: 140)
/// ```
class AnimatedLogo extends StatefulWidget {
  /// Diameter of the circular logo container in logical pixels.
  final double size;

  const AnimatedLogo({super.key, this.size = 140});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Animate the blur radius from 20 → 40 using a smooth ease-in-out curve.
    _glowAnimation = Tween<double>(begin: 20, end: 40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerLowest,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(
                  alpha: _glowAnimation.value / 100,
                ),
                blurRadius: _glowAnimation.value,
                spreadRadius: _glowAnimation.value * 0.1,
              ),
            ],
          ),
          child: child,
        );
      },
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(widget.size * 0.18),
          child: AppBrandLogo.custom(dimension: widget.size * 0.64),
        ),
      ),
    );
  }
}

