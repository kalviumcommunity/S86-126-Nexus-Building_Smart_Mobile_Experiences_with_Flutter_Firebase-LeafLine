import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  bool _isLoading = false;
  String? _editingTaskId;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  User? get _user => _authService.currentUser;

  /// Validate form inputs
  bool _validateInputs() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final priority = _priorityController.text.trim();

    if (title.isEmpty) {
      _showSnackBar('Title is required');
      return false;
    }

    if (title.length < 3) {
      _showSnackBar('Title must be at least 3 characters');
      return false;
    }

    if (description.isEmpty) {
      _showSnackBar('Description is required');
      return false;
    }

    if (description.length < 10) {
      _showSnackBar('Description must be at least 10 characters');
      return false;
    }

    if (priority.isNotEmpty &&
        !['low', 'medium', 'high'].contains(priority.toLowerCase())) {
      _showSnackBar('Priority must be: low, medium, or high');
      return false;
    }

    return true;
  }

  /// Add new task using .add() (auto-generated ID)
  Future<void> _addTask() async {
    if (!_validateInputs() || _user == null) return;

    setState(() => _isLoading = true);

    try {
      await _firestoreService.addTask(_user!.uid, {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'priority': _priorityController.text.trim().toLowerCase(),
        'isCompleted': false,
      });

      _clearForm();
      _showSnackBar('Task added successfully!');
    } catch (e) {
      _showSnackBar('Failed to add task: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Set task with specific ID using .set()
  Future<void> _setTaskWithId() async {
    if (!_validateInputs() || _user == null) return;

    final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';

    setState(() => _isLoading = true);

    try {
      await _firestoreService.setTask(taskId, _user!.uid, {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'priority': _priorityController.text.trim().toLowerCase(),
        'isCompleted': false,
      });

      _clearForm();
      _showSnackBar('Task set with ID: $taskId');
    } catch (e) {
      _showSnackBar('Failed to set task: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Update existing task using .update()
  Future<void> _updateTask(String taskId) async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      await _firestoreService.updateTask(taskId, {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'priority': _priorityController.text.trim().toLowerCase(),
      });

      _clearForm();
      setState(() => _editingTaskId = null);
      _showSnackBar('Task updated successfully!');
    } catch (e) {
      _showSnackBar('Failed to update task: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Toggle task completion status
  Future<void> _toggleTaskCompletion(String taskId, bool currentStatus) async {
    try {
      await _firestoreService.toggleTaskCompletion(taskId, currentStatus);
    } catch (e) {
      _showSnackBar('Failed to update task status');
    }
  }

  /// Delete task
  Future<void> _deleteTask(String taskId) async {
    try {
      await _firestoreService.deleteTask(taskId);
      _showSnackBar('Task deleted');
    } catch (e) {
      _showSnackBar('Failed to delete task');
    }
  }

  /// Load task data for editing
  void _loadTaskForEditing(DocumentSnapshot task) {
    final data = task.data() as Map<String, dynamic>;
    _titleController.text = data['title'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _priorityController.text = data['priority'] ?? '';
    setState(() => _editingTaskId = task.id);
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _priorityController.clear();
    setState(() => _editingTaskId = null);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management - Write Operations'),
        backgroundColor: Colors.blue,
        actions: [
          if (_editingTaskId != null)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _clearForm,
              tooltip: 'Cancel editing',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firestore Write Operations Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demonstrates: add(), set(), update() operations with validation',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Input Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _editingTaskId != null ? 'Edit Task' : 'Create New Task',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title *',
                        hintText: 'Enter task title (min 3 characters)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        hintText:
                            'Enter detailed description (min 10 characters)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _priorityController,
                      decoration: const InputDecoration(
                        labelText: 'Priority (optional)',
                        hintText: 'low, medium, or high',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _addTask,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Task (.add())'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _setTaskWithId,
                            icon: const Icon(Icons.save),
                            label: const Text('Set Task (.set())'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (_editingTaskId != null) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _updateTask(_editingTaskId!),
                          icon: const Icon(Icons.update),
                          label: const Text('Update Task (.update())'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tasks List
            const Text(
              'Your Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getTasksStream(_user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data?.docs ?? [];

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text('No tasks yet. Add your first task above!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final data = task.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            data['title'] ?? 'Untitled',
                            style: TextStyle(
                              decoration: data['isCompleted'] == true
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['description'] ?? ''),
                              if (data['priority'] != null)
                                Chip(
                                  label: Text(data['priority']),
                                  backgroundColor: _getPriorityColor(
                                    data['priority'],
                                  ),
                                ),
                            ],
                          ),
                          leading: Checkbox(
                            value: data['isCompleted'] ?? false,
                            onChanged: (value) => _toggleTaskCompletion(
                              task.id,
                              data['isCompleted'] ?? false,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _loadTaskForEditing(task),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteTask(task.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'low':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
