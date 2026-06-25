import 'package:flutter/material.dart';

class ShimmerLoadingSkeleton extends StatefulWidget {
  const ShimmerLoadingSkeleton({
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 12,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerLoadingSkeleton> createState() => _ShimmerLoadingSkeletonState();
}

class _ShimmerLoadingSkeletonState extends State<ShimmerLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + (_controller.value * 2), 0),
              end: Alignment(_controller.value * 2, 0),
              colors: [
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              ],
            ),
          ),
        );
      },
    );
  }
}
