import 'package:flutter/material.dart';

/// Error State Widget
///
/// Reusable widget to display error states with retry functionality.
/// Provides a consistent, user-friendly error experience.
class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final String? title;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? technicalDetails;
  final bool showTechnicalDetails;

  const ErrorStateWidget({
    super.key,
    this.message,
    this.title,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.technicalDetails,
    this.showTechnicalDetails = false,
  });

  /// Factory constructor for network errors
  factory ErrorStateWidget.network({VoidCallback? onRetry, String? message}) {
    return ErrorStateWidget(
      title: 'Connection Error',
      message:
          message ??
          'Unable to connect to the server.\nPlease check your internet connection.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for permission errors
  factory ErrorStateWidget.permission({
    VoidCallback? onRetry,
    String? message,
  }) {
    return ErrorStateWidget(
      title: 'Permission Denied',
      message: message ?? 'You don\'t have permission to access this resource.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for not found errors
  factory ErrorStateWidget.notFound({VoidCallback? onRetry, String? message}) {
    return ErrorStateWidget(
      title: 'Not Found',
      message: message ?? 'The requested resource could not be found.',
      icon: Icons.search_off,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for generic errors
  factory ErrorStateWidget.generic({
    VoidCallback? onRetry,
    String? message,
    String? technicalDetails,
  }) {
    return ErrorStateWidget(
      title: 'Something Went Wrong',
      message: message ?? 'An unexpected error occurred.\nPlease try again.',
      icon: Icons.error_outline,
      onRetry: onRetry,
      technicalDetails: technicalDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Icon(
              icon,
              size: 80,
              color: theme.colorScheme.error.withOpacity(0.7),
            ),
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
            Text(
              message ?? 'An error occurred',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            // Technical Details (expandable)
            if (showTechnicalDetails && technicalDetails != null) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Technical Details'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      technicalDetails!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],

            // Additional Help Text
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _showHelpDialog(context);
                },
                child: const Text('Need Help?'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Troubleshooting Tips'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Check your internet connection'),
              SizedBox(height: 8),
              Text('• Make sure you\'re logged in'),
              SizedBox(height: 8),
              Text('• Try closing and reopening the app'),
              SizedBox(height: 8),
              Text('• Clear app cache if the problem persists'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

/// Compact Error Widget
///
/// A smaller error widget suitable for inline error displays
class CompactErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CompactErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRetry,
              tooltip: 'Retry',
            ),
          ],
        ],
      ),
    );
  }
}
