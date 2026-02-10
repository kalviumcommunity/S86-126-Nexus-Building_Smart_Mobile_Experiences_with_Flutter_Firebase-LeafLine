import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_item.dart';
import '../providers/items_provider.dart';
import '../utils/form_validators.dart';

/// Enhanced Item Form with comprehensive validation
/// 
/// Features:
/// - Complex form validation
/// - Real-time validation feedback
/// - Create and edit modes
/// - Category selection
/// - Character counters
/// - Responsive UI
class EnhancedItemForm extends StatefulWidget {
  final UserItem? item; // null for create, non-null for edit

  const EnhancedItemForm({super.key, this.item});

  @override
  State<EnhancedItemForm> createState() => _EnhancedItemFormState();
}

class _EnhancedItemFormState extends State<EnhancedItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  bool _isCompleted = false;
  bool _isSaving = false;
  bool _autoValidate = false;

  final List<String> _categories = [
    'Personal',
    'Work',
    'Shopping',
    'Ideas',
    'Tasks',
    'Notes',
    'Goals',
    'Projects',
  ];

  @override
  void initState() {
    super.initState();
    
    // Pre-fill form if editing
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description;
      _selectedCategory = widget.item!.category;
      _isCompleted = widget.item!.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    setState(() => _autoValidate = true);

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final itemsProvider = context.read<ItemsProvider>();
    bool success;

    if (widget.item == null) {
      // Create new item
      success = await itemsProvider.createItem(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        isCompleted: _isCompleted,
      );
    } else {
      // Update existing item
      final updatedItem = widget.item!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        isCompleted: _isCompleted,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      success = await itemsProvider.updateItem(updatedItem);
    }

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.item == null
                ? 'Item created successfully!'
                : 'Item updated successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(itemsProvider.error ?? 'Failed to save item'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Create New Item'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Fill out all required fields. Title must be 3-50 characters, description 10-500 characters.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  hintText: 'Enter item title',
                  prefixIcon: const Icon(Icons.title),
                  suffixText: '${_titleController.text.length}/50',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLength: 50,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => FormValidators.combine([
                  (v) => FormValidators.validateRequired(v, fieldName: 'Title'),
                  (v) => FormValidators.validateLengthRange(
                        v,
                        3,
                        50,
                        fieldName: 'Title',
                      ),
                ])(value),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Enter detailed description',
                  prefixIcon: const Icon(Icons.description),
                  suffixText: '${_descriptionController.text.length}/500',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => FormValidators.combine([
                  (v) => FormValidators.validateRequired(v, fieldName: 'Description'),
                  (v) => FormValidators.validateLengthRange(
                        v,
                        10,
                        500,
                        fieldName: 'Description',
                      ),
                ])(value),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                hint: const Text('Select a category (optional)'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 16),

              // Completion status toggle
              Card(
                child: SwitchListTile(
                  title: const Text('Mark as Completed'),
                  subtitle: Text(
                    _isCompleted
                        ? 'This item is marked as done'
                        : 'This item is pending',
                  ),
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() => _isCompleted = value);
                  },
                  secondary: Icon(
                    _isCompleted ? Icons.check_circle : Icons.circle_outlined,
                    color: _isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Validation summary
              if (_autoValidate && !_formKey.currentState!.validate())
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Please review and fix the validation errors above',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveItem,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(isEditing ? 'Update Item' : 'Create Item'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
