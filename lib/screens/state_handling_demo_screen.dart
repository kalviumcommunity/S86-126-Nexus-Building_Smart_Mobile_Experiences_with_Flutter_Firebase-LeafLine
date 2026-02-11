import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';

/// State Handling Demo Screen
///
/// Demonstrates proper loading, error, and empty state handling.
/// Shows best practices for UI states in Flutter applications.
class StateHandlingDemoScreen extends StatefulWidget {
  const StateHandlingDemoScreen({super.key});

  @override
  State<StateHandlingDemoScreen> createState() =>
      _StateHandlingDemoScreenState();
}

class _StateHandlingDemoScreenState extends State<StateHandlingDemoScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State Handling Demo'), elevation: 2),
      body: Column(
        children: [
          // Tab Selection
          _buildTabBar(),

          // Content based on selected tab
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab('Loading', 0, Icons.hourglass_empty),
          _buildTab('Error', 1, Icons.error_outline),
          _buildTab('Empty', 2, Icons.inbox),
          _buildTab('Async', 3, Icons.cloud_sync),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon) {
    final theme = Theme.of(context);
    final isSelected = _selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color?.withOpacity(0.6),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.textTheme.labelSmall?.color?.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return const LoadingStatesDemo();
      case 1:
        return const ErrorStatesDemo();
      case 2:
        return const EmptyStatesDemo();
      case 3:
        return const AsyncStatesDemo();
      default:
        return const SizedBox();
    }
  }
}

/// Loading States Demo
class LoadingStatesDemo extends StatelessWidget {
  const LoadingStatesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Circular Loader',
          'Default loading indicator',
          const LoadingStateWidget(),
        ),
        _buildSection(
          context,
          'With Message',
          'Loading indicator with text',
          const LoadingStateWidget(message: 'Loading your data...'),
        ),
        _buildSection(
          context,
          'Linear Loader',
          'Linear progress indicator',
          const LoadingStateWidget(
            style: LoadingStyle.linear,
            message: 'Please wait...',
          ),
        ),
        _buildSection(
          context,
          'Skeleton Loader',
          'Shimmer effect for better UX',
          const SizedBox(height: 300, child: ListSkeletonLoader(itemCount: 3)),
        ),
        _buildSection(
          context,
          'Custom Loader',
          'Custom styled loading animation',
          const LoadingStateWidget(
            style: LoadingStyle.custom,
            size: 60,
            message: 'Processing...',
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String description,
    Widget content,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            SizedBox(height: 150, child: content),
          ],
        ),
      ),
    );
  }
}

/// Error States Demo
class ErrorStatesDemo extends StatelessWidget {
  const ErrorStatesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildExample(
          context,
          'Network Error',
          ErrorStateWidget.network(
            onRetry: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Retrying...')));
            },
          ),
        ),
        _buildExample(
          context,
          'Permission Error',
          ErrorStateWidget.permission(onRetry: () {}),
        ),
        _buildExample(context, 'Not Found Error', ErrorStateWidget.notFound()),
        _buildExample(
          context,
          'Generic Error',
          ErrorStateWidget.generic(
            onRetry: () {},
            technicalDetails: 'Error code: 500\nStack trace: ...',
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compact Error Widget',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                CompactErrorWidget(
                  message: 'Failed to load data',
                  onRetry: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExample(BuildContext context, String title, Widget content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          SizedBox(height: 300, child: content),
        ],
      ),
    );
  }
}

/// Empty States Demo
class EmptyStatesDemo extends StatelessWidget {
  const EmptyStatesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildExample(
          context,
          'Empty List',
          EmptyStateWidget.list(
            onAction: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Add item clicked')));
            },
          ),
        ),
        _buildExample(
          context,
          'No Search Results',
          EmptyStateWidget.search(query: 'Flutter', onClear: () {}),
        ),
        _buildExample(
          context,
          'No Favorites',
          EmptyStateWidget.favorites(onBrowse: () {}),
        ),
        _buildExample(
          context,
          'No Notifications',
          EmptyStateWidget.notifications(),
        ),
        _buildExample(
          context,
          'Offline State',
          EmptyStateWidget.offline(onRetry: () {}),
        ),
        _buildExample(context, 'All Completed', EmptyStateWidget.completed()),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compact Empty Widget',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  height: 120,
                  child: CompactEmptyWidget(
                    message: 'No items to display',
                    icon: Icons.inbox,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExample(BuildContext context, String title, Widget content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          SizedBox(height: 300, child: content),
        ],
      ),
    );
  }
}

/// Async States Demo
/// Demonstrates FutureBuilder and StreamBuilder patterns
class AsyncStatesDemo extends StatefulWidget {
  const AsyncStatesDemo({super.key});

  @override
  State<AsyncStatesDemo> createState() => _AsyncStatesDemoState();
}

class _AsyncStatesDemoState extends State<AsyncStatesDemo> {
  bool _showFutureExample = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toggle between FutureBuilder and StreamBuilder
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('FutureBuilder'),
                icon: Icon(Icons.access_time),
              ),
              ButtonSegment(
                value: false,
                label: Text('StreamBuilder'),
                icon: Icon(Icons.stream),
              ),
            ],
            selected: {_showFutureExample},
            onSelectionChanged: (Set<bool> selection) {
              setState(() {
                _showFutureExample = selection.first;
              });
            },
          ),
        ),
        Expanded(
          child: _showFutureExample
              ? const FutureBuilderExample()
              : const StreamBuilderExample(),
        ),
      ],
    );
  }
}

/// FutureBuilder Example
class FutureBuilderExample extends StatefulWidget {
  const FutureBuilderExample({super.key});

  @override
  State<FutureBuilderExample> createState() => _FutureBuilderExampleState();
}

class _FutureBuilderExampleState extends State<FutureBuilderExample> {
  late Future<List<String>> _dataFuture;
  bool _shouldFail = false;
  bool _shouldReturnEmpty = false;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<List<String>> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_shouldFail) {
      throw Exception('Failed to load data');
    }

    if (_shouldReturnEmpty) {
      return [];
    }

    return ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  }

  void _retry() {
    setState(() {
      _dataFuture = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Control buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _shouldFail = false;
                    _shouldReturnEmpty = false;
                    _retry();
                  });
                },
                child: const Text('Load Success'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _shouldFail = true;
                    _shouldReturnEmpty = false;
                    _retry();
                  });
                },
                child: const Text('Load Error'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _shouldFail = false;
                    _shouldReturnEmpty = true;
                    _retry();
                  });
                },
                child: const Text('Load Empty'),
              ),
            ],
          ),
        ),

        // FutureBuilder
        Expanded(
          child: FutureBuilder<List<String>>(
            future: _dataFuture,
            builder: (context, snapshot) {
              // Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingStateWidget(message: 'Loading data...');
              }

              // Error State
              if (snapshot.hasError) {
                return ErrorStateWidget.generic(
                  message: 'Failed to load data',
                  technicalDetails: snapshot.error.toString(),
                  onRetry: _retry,
                );
              }

              // Empty State
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return EmptyStateWidget.list(
                  title: 'No Data',
                  message: 'Try loading the success state',
                );
              }

              // Success State
              final data = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(data[index]),
                      subtitle: const Text('Loaded successfully'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// StreamBuilder Example
class StreamBuilderExample extends StatefulWidget {
  const StreamBuilderExample({super.key});

  @override
  State<StreamBuilderExample> createState() => _StreamBuilderExampleState();
}

class _StreamBuilderExampleState extends State<StreamBuilderExample> {
  late Stream<List<String>> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = _createStream();
  }

  Stream<List<String>> _createStream() {
    return Stream.periodic(const Duration(seconds: 2), (count) {
      if (count % 3 == 0) {
        return ['Real-time item ${count + 1}'];
      }
      return List.generate(count + 1, (i) => 'Real-time item ${i + 1}');
    }).take(10);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _dataStream,
      builder: (context, snapshot) {
        // Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingStateWidget(message: 'Connecting to stream...');
        }

        // Error State
        if (snapshot.hasError) {
          return ErrorStateWidget.network(message: 'Stream connection failed');
        }

        // Empty State
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyStateWidget(
            title: 'Waiting for Data',
            message: 'The stream will emit data shortly...',
            icon: Icons.stream,
          );
        }

        // Success State
        final data = snapshot.data!;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Stream Active - ${data.length} items',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.stream)),
                      title: Text(data[index]),
                      subtitle: Text(
                        'Updated at ${DateTime.now().toString().substring(11, 19)}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
