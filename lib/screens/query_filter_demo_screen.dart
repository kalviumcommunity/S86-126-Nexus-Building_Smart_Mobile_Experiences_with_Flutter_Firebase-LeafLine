import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueryFilterDemoScreen extends StatefulWidget {
  const QueryFilterDemoScreen({super.key});

  @override
  State<QueryFilterDemoScreen> createState() => _QueryFilterDemoScreenState();
}

class _QueryFilterDemoScreenState extends State<QueryFilterDemoScreen> {
  String _selectedFilter = 'all'; // all, active, completed, high, medium, low
  String _sortBy = 'createdAt'; // createdAt, priority, title
  bool _descending = true;
  int _limitCount = 20;

  final Map<String, IconData> _priorityIcons = {
    'high': Icons.priority_high,
    'medium': Icons.remove,
    'low': Icons.arrow_downward,
  };

  final Map<String, Color> _priorityColors = {
    'high': Colors.red,
    'medium': Colors.orange,
    'low': Colors.green,
  };

  /// Build the Firestore query based on selected filters
  Query<Map<String, dynamic>> _buildQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
      'tasks',
    );

    // Apply filters
    switch (_selectedFilter) {
      case 'active':
        query = query.where('isCompleted', isEqualTo: false);
        break;
      case 'completed':
        query = query.where('isCompleted', isEqualTo: true);
        break;
      case 'high':
        query = query.where('priority', isEqualTo: 'high');
        break;
      case 'medium':
        query = query.where('priority', isEqualTo: 'medium');
        break;
      case 'low':
        query = query.where('priority', isEqualTo: 'low');
        break;
      default:
        // 'all' - no filter
        break;
    }

    // Apply sorting
    query = query.orderBy(_sortBy, descending: _descending);

    // Apply limit
    query = query.limit(_limitCount);

    return query;
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Tasks'),
              leading: Radio<String>(
                value: 'all',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Active Tasks'),
              leading: Radio<String>(
                value: 'active',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Completed Tasks'),
              leading: Radio<String>(
                value: 'completed',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('High Priority'),
              leading: Radio<String>(
                value: 'high',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Medium Priority'),
              leading: Radio<String>(
                value: 'medium',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Low Priority'),
              leading: Radio<String>(
                value: 'low',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show sort dialog
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort by Date'),
              leading: Radio<String>(
                value: 'createdAt',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Sort by Priority'),
              leading: Radio<String>(
                value: 'priority',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Sort by Title'),
              leading: Radio<String>(
                value: 'title',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Descending'),
              value: _descending,
              onChanged: (value) {
                setState(() => _descending = value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show limit dialog
  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Result Limit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [10, 20, 50, 100].map((limit) {
            return ListTile(
              title: Text('Limit to $limit items'),
              leading: Radio<int>(
                value: limit,
                groupValue: _limitCount,
                onChanged: (value) {
                  setState(() => _limitCount = value!);
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Show query info dialog
  void _showQueryInfo() {
    String filterText = _selectedFilter == 'all'
        ? 'No filter'
        : 'where(\'${_selectedFilter == 'active' || _selectedFilter == 'completed' ? 'isCompleted' : 'priority'}\', isEqualTo: ${_selectedFilter == 'active'
              ? false
              : _selectedFilter == 'completed'
              ? true
              : '\'$_selectedFilter\''})';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Current Query Structure'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your current Firestore query:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'FirebaseFirestore.instance\n'
                  '  .collection(\'tasks\')\n'
                  '  ${_selectedFilter != 'all' ? '$filterText\n  ' : ''}'
                  '.orderBy(\'$_sortBy\', descending: $_descending)\n'
                  '  .limit($_limitCount)\n'
                  '  .snapshots()',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Query Explanation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('• Collection: tasks'),
              if (_selectedFilter != 'all')
                Text('• Filter: ${_getFilterDescription()}'),
              Text(
                '• Sort: ${_sortBy.replaceAll('_', ' ')} (${_descending ? 'newest/highest first' : 'oldest/lowest first'})',
              ),
              Text('• Limit: First $_limitCount results'),
              const SizedBox(height: 16),
              const Text(
                '💡 Tip: Firestore automatically creates indexes for simple queries. Complex queries may require composite indexes.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getFilterDescription() {
    switch (_selectedFilter) {
      case 'active':
        return 'Show only incomplete tasks';
      case 'completed':
        return 'Show only completed tasks';
      case 'high':
        return 'Show only high priority tasks';
      case 'medium':
        return 'Show only medium priority tasks';
      case 'low':
        return 'Show only low priority tasks';
      default:
        return 'No filter applied';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Queries & Filters'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showQueryInfo,
            tooltip: 'View Query Structure',
          ),
        ],
      ),
      body: Column(
        children: [
          // Control Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              border: Border(
                bottom: BorderSide(color: Colors.deepPurple[100]!),
              ),
            ),
            child: Column(
              children: [
                // Filter, Sort, Limit buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showFilterDialog,
                        icon: const Icon(Icons.filter_list),
                        label: Text(
                          _selectedFilter == 'all'
                              ? 'Filter'
                              : _selectedFilter.toUpperCase(),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedFilter == 'all'
                              ? Colors.grey
                              : Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showSortDialog,
                        icon: Icon(
                          _descending
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                        ),
                        label: Text(_sortBy.toUpperCase()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showLimitDialog,
                        icon: const Icon(Icons.numbers),
                        label: Text('$_limitCount'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Current query description
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepPurple[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing: ${_getFilterDescription()} • Sorted by: $_sortBy • Limit: $_limitCount',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading tasks...'),
                      ],
                    ),
                  );
                }

                // Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 8),
                        const Text(
                          'This might require a Firestore index.\nCheck console for index creation link.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Empty state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No tasks found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try changing your filter or add some tasks',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                // Data state
                final docs = snapshot.data!.docs;

                return Column(
                  children: [
                    // Results count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.green[50],
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Found ${docs.length} task${docs.length == 1 ? '' : 's'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // Task list
                    Expanded(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final task = docs[index];
                          final data = task.data() as Map<String, dynamic>;
                          final title = data['title'] ?? 'Untitled';
                          final description = data['description'] ?? '';
                          final priority = data['priority'] ?? 'low';
                          final isCompleted = data['isCompleted'] ?? false;
                          final createdAt = data['createdAt'];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    _priorityColors[priority] ?? Colors.grey,
                                child: Icon(
                                  _priorityIcons[priority] ?? Icons.task,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isCompleted
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (description.isNotEmpty)
                                    Text(
                                      description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isCompleted
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Chip(
                                        label: Text(
                                          priority.toUpperCase(),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        backgroundColor:
                                            _priorityColors[priority]
                                                ?.withOpacity(0.2),
                                        padding: EdgeInsets.zero,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      if (createdAt != null)
                                        Chip(
                                          label: Text(
                                            _formatDate(createdAt),
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          avatar: const Icon(
                                            Icons.access_time,
                                            size: 14,
                                          ),
                                          padding: EdgeInsets.zero,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isCompleted ? Colors.green : Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQueryInfo,
        icon: const Icon(Icons.code),
        label: const Text('View Query'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'No date';
    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        final now = DateTime.now();
        final diff = now.difference(date);

        if (diff.inMinutes < 1) return 'Just now';
        if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
        if (diff.inHours < 24) return '${diff.inHours}h ago';
        if (diff.inDays < 7) return '${diff.inDays}d ago';

        return '${date.day}/${date.month}/${date.year}';
      }
      return 'Invalid date';
    } catch (e) {
      return 'Error';
    }
  }
}
