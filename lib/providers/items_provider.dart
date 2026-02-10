import 'package:flutter/foundation.dart';
import '../models/user_item.dart';
import '../services/crud_service.dart';

/// State provider for managing user items with Provider pattern
/// 
/// This provider handles:
/// - Loading items from Firestore
/// - Creating, updating, and deleting items
/// - Filtering and searching items
/// - Managing loading and error states
/// - Notifying listeners of state changes
class ItemsProvider with ChangeNotifier {
  final CrudService _crudService = CrudService();
  
  List<UserItem> _items = [];
  List<UserItem> _filteredItems = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategory;
  bool? _filterCompleted;
  String _searchQuery = '';

  // Getters
  List<UserItem> get items => _filteredItems;
  List<UserItem> get allItems => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  bool? get filterCompleted => _filterCompleted;
  String get searchQuery => _searchQuery;

  // Statistics
  int get totalItems => _items.length;
  int get completedItems => _items.where((item) => item.isCompleted).length;
  int get pendingItems => _items.where((item) => !item.isCompleted).length;
  Map<String, int> get itemsByCategory {
    final Map<String, int> categoryCount = {};
    for (var item in _items) {
      if (item.category != null) {
        categoryCount[item.category!] = (categoryCount[item.category!] ?? 0) + 1;
      }
    }
    return categoryCount;
  }

  /// Load items from Firestore
  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final items = await _crudService.getAllItems();
      _items = items;
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _items = [];
      _filteredItems = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new item
  Future<bool> createItem({
    required String title,
    required String description,
    String? category,
    bool isCompleted = false,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _crudService.createItem(
        title: title,
        description: description,
        category: category,
        isCompleted: isCompleted,
      );

      await loadItems();
      return true;
    } catch (e) {
      _error = 'Failed to create item: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update an existing item
  Future<bool> updateItem(UserItem item) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _crudService.updateItem(
        itemId: item.id,
        title: item.title,
        description: item.description,
        category: item.category,
        isCompleted: item.isCompleted,
      );

      await loadItems();
      return true;
    } catch (e) {
      _error = 'Failed to update item: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete an item
  Future<bool> deleteItem(String itemId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _crudService.deleteItem(itemId);
      await loadItems();
      return true;
    } catch (e) {
      _error = 'Failed to delete item: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle item completion status
  Future<void> toggleItemCompletion(UserItem item) async {
    final updatedItem = item.copyWith(
      isCompleted: !item.isCompleted,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await updateItem(updatedItem);
  }

  /// Set category filter
  void setCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Set completion filter
  void setCompletionFilter(bool? isCompleted) {
    _filterCompleted = isCompleted;
    _applyFilters();
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategory = null;
    _filterCompleted = null;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  /// Apply current filters to items
  void _applyFilters() {
    _filteredItems = _items.where((item) {
      // Category filter
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }

      // Completion filter
      if (_filterCompleted != null && item.isCompleted != _filterCompleted) {
        return false;
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final titleMatch = item.title.toLowerCase().contains(_searchQuery);
        final descMatch = item.description.toLowerCase().contains(_searchQuery);
        if (!titleMatch && !descMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Delete all completed items
  Future<void> deleteCompletedItems() async {
    final completedIds = _items
        .where((item) => item.isCompleted)
        .map((item) => item.id)
        .toList();

    for (var id in completedIds) {
      await _crudService.deleteItem(id);
    }

    await loadItems();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh items
  Future<void> refresh() async {
    await loadItems();
  }
}
