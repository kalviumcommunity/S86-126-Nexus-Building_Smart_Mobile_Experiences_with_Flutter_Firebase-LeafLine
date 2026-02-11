import 'package:flutter/material.dart';

/// Empty State Widget
///
/// Reusable widget to display empty states with helpful messages and CTAs.
/// Makes the app feel more polished and guides users.
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customAction;
  final Color? iconColor;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.icon = Icons.inbox,
    this.actionLabel,
    this.onAction,
    this.customAction,
    this.iconColor,
    this.iconSize = 80,
  });

  /// Factory constructor for empty list
  factory EmptyStateWidget.list({
    String? title,
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      title: title ?? 'No Items Yet',
      message: message ?? 'Get started by adding your first item.',
      icon: Icons.list_alt,
      actionLabel: actionLabel ?? 'Add Item',
      onAction: onAction,
    );
  }

  /// Factory constructor for no search results
  factory EmptyStateWidget.search({String? query, VoidCallback? onClear}) {
    return EmptyStateWidget(
      title: 'No Results Found',
      message: query != null
          ? 'No results for "$query".\nTry different keywords.'
          : 'Try adjusting your search.',
      icon: Icons.search_off,
      actionLabel: 'Clear Search',
      onAction: onClear,
    );
  }

  /// Factory constructor for no favorites
  factory EmptyStateWidget.favorites({VoidCallback? onBrowse}) {
    return EmptyStateWidget(
      title: 'No Favorites Yet',
      message: 'Items you favorite will appear here.\nStart exploring!',
      icon: Icons.favorite_border,
      actionLabel: 'Browse Items',
      onAction: onBrowse,
      iconColor: Colors.pink,
    );
  }

  /// Factory constructor for no notifications
  factory EmptyStateWidget.notifications() {
    return const EmptyStateWidget(
      title: 'No Notifications',
      message:
          'You\'re all caught up!\nWe\'ll notify you when something new arrives.',
      icon: Icons.notifications_none,
    );
  }

  /// Factory constructor for offline state
  factory EmptyStateWidget.offline({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      title: 'You\'re Offline',
      message: 'Connect to the internet to see your content.',
      icon: Icons.cloud_off,
      actionLabel: 'Retry',
      onAction: onRetry,
      iconColor: Colors.orange,
    );
  }

  /// Factory constructor for completed tasks
  factory EmptyStateWidget.completed() {
    return const EmptyStateWidget(
      title: 'All Done!',
      message: 'Great job! You\'ve completed all your tasks.',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor =
        iconColor ?? theme.colorScheme.primary.withOpacity(0.5);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(icon, size: iconSize, color: effectiveIconColor),
            const SizedBox(height: 24),

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            // Message
            if (message != null) ...[
              Text(
                message!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button or Custom Action
            if (customAction != null) ...[
              const SizedBox(height: 32),
              customAction!,
            ] else if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact Empty Widget
///
/// A smaller empty state widget for inline displays
class CompactEmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const CompactEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated Empty State
///
/// Empty state with subtle animations for a more polished feel
class AnimatedEmptyState extends StatefulWidget {
  final EmptyStateWidget child;

  const AnimatedEmptyState({super.key, required this.child});

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
