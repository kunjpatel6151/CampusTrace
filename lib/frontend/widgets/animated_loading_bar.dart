// animated_loading_bar.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/theme/app_colors.dart';

/// An infinitely animating loading bar that mimics the Stitch design's
/// progress indicator — the filled portion slides from left to right,
/// expanding and then contracting.
///
/// Usage:
/// ```dart
/// const AnimatedLoadingBar(width: 280, height: 4)
/// ```
class AnimatedLoadingBar extends StatefulWidget {
  /// Total width of the loading bar track.
  final double width;

  /// Height (thickness) of the bar.
  final double height;

  const AnimatedLoadingBar({
    super.key,
    this.width = 280,
    this.height = 4,
  });

  @override
  State<AnimatedLoadingBar> createState() => _AnimatedLoadingBarState();
}

class _AnimatedLoadingBarState extends State<AnimatedLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height / 2),
        child: Stack(
          children: [
            // Track background
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
            ),
            // Animated fill
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // Replicate the CSS keyframes:
                //   0%   → width: 0%,   margin-left: 0%
                //   50%  → width: 100%, margin-left: 0%
                //   100% → width: 0%,   margin-left: 100%
                final double t = _controller.value;

                double barWidth;
                double leftOffset;

                if (t <= 0.5) {
                  // First half: bar grows from 0 → full width.
                  final progress = t / 0.5; // 0 → 1
                  barWidth = widget.width * Curves.easeInOut.transform(progress);
                  leftOffset = 0;
                } else {
                  // Second half: bar shrinks from full → 0, sliding right.
                  final progress = (t - 0.5) / 0.5; // 0 → 1
                  final eased = Curves.easeInOut.transform(progress);
                  barWidth = widget.width * (1 - eased);
                  leftOffset = widget.width * eased;
                }

                return Positioned(
                  left: leftOffset,
                  top: 0,
                  bottom: 0,
                  width: barWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(widget.height / 2),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
