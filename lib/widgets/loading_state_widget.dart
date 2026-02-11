import 'package:flutter/material.dart';

/// Loading State Widget
///
/// Reusable widget to display loading states consistently across the app.
/// Supports different loading styles and optional messages.
class LoadingStateWidget extends StatelessWidget {
  final String? message;
  final LoadingStyle style;
  final Color? color;
  final double size;

  const LoadingStateWidget({
    super.key,
    this.message,
    this.style = LoadingStyle.circular,
    this.color,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Loading indicator based on style
          _buildLoadingIndicator(effectiveColor),

          // Optional message
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    switch (style) {
      case LoadingStyle.circular:
        return CircularProgressIndicator(color: color, strokeWidth: 3.0);

      case LoadingStyle.linear:
        return SizedBox(
          width: 200,
          child: LinearProgressIndicator(color: color),
        );

      case LoadingStyle.adaptive:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );

      case LoadingStyle.custom:
        return _buildCustomLoader(color);
    }
  }

  Widget _buildCustomLoader(Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CircularProgressIndicator(
            color: color.withOpacity(0.3),
            strokeWidth: 2,
          ),
          Positioned.fill(
            child: CircularProgressIndicator(color: color, strokeWidth: 2),
          ),
        ],
      ),
    );
  }
}

/// Skeleton Loading Widget
///
/// Shows a shimmer effect for content that is loading,
/// providing a better perceived performance.
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16.0,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _animation.value - 0.1,
                _animation.value,
                _animation.value + 0.1,
              ],
              colors: isDark
                  ? [Colors.grey[800]!, Colors.grey[700]!, Colors.grey[800]!]
                  : [Colors.grey[300]!, Colors.grey[200]!, Colors.grey[300]!],
            ),
          ),
        );
      },
    );
  }
}

/// List Skeleton Loader
///
/// Displays multiple skeleton items for list loading states
class ListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;

  const ListSkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SkeletonLoader(
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      SkeletonLoader(
                        width: 200,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
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
}

/// Loading Style Enum
enum LoadingStyle { circular, linear, adaptive, custom }
