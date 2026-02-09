import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_item.dart';

/// Service class for handling CRUD operations on user items
/// 
/// This service manages Create, Read, Update, and Delete operations
/// for user-specific items stored in Firestore under:
/// /users/{uid}/items/{itemId}
/// 
/// All operations are user-scoped and require authentication.
class CrudService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CrudService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Get the current authenticated user's ID
  /// Throws [StateError] if no user is signed in
  String get _currentUserId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('No user is currently signed in. Please authenticate first.');
    }
    return uid;
  }

  /// Get reference to the current user's items collection
  CollectionReference<Map<String, dynamic>> get _itemsCollection {
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('items');
  }

  // ==================== CREATE ====================

  /// Create a new item for the current user
  /// 
  /// Returns the ID of the newly created document
  /// 
  /// Example:
  /// ```dart
  /// final itemId = await crudService.createItem(
  ///   title: 'My Task',
  ///   description: 'Complete the Flutter assignment',
  ///   category: 'Work',
  /// );
  /// ```
  Future<String> createItem({
    required String title,
    required String description,
    String? category,
    bool isCompleted = false,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      final docRef = await _itemsCollection.add({
        'title': title,
        'description': description,
        'createdAt': now,
        'updatedAt': null,
        'category': category,
        'isCompleted': isCompleted,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  /// Create multiple items in a batch operation
  /// 
  /// More efficient than creating items one by one
  /// Returns the number of items created successfully
  Future<int> createItemsBatch(List<Map<String, dynamic>> items) async {
    try {
      final batch = _firestore.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final itemData in items) {
        final docRef = _itemsCollection.doc();
        batch.set(docRef, {
          ...itemData,
          'createdAt': now,
          'updatedAt': null,
        });
      }

      await batch.commit();
      return items.length;
    } catch (e) {
      throw Exception('Failed to create items in batch: $e');
    }
  }

  // ==================== READ ====================

  /// Get a stream of all items for the current user
  /// 
  /// Items are automatically ordered by creation date (newest first)
  /// The stream updates in real-time when items are added/updated/deleted
  /// 
  /// Example:
  /// ```dart
  /// StreamBuilder<List<UserItem>>(
  ///   stream: crudService.getItemsStream(),
  ///   builder: (context, snapshot) {
  ///     if (snapshot.hasData) {
  ///       final items = snapshot.data!;
  ///       return ListView.builder(...);
  ///     }
  ///     return CircularProgressIndicator();
  ///   },
  /// )
  /// ```
  Stream<List<UserItem>> getItemsStream({
    String? category,
    bool? isCompleted,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _itemsCollection;

    // Apply filters if provided
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    if (isCompleted != null) {
      query = query.where('isCompleted', isEqualTo: isCompleted);
    }

    // Order by creation date (newest first)
    query = query.orderBy('createdAt', descending: true);

    // Apply limit if provided
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserItem.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  /// Get a single item by ID
  /// 
  /// Returns null if the item doesn't exist
  Future<UserItem?> getItemById(String itemId) async {
    try {
      final doc = await _itemsCollection.doc(itemId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return UserItem.fromFirestore(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get item: $e');
    }
  }

  /// Get all items as a one-time fetch (not real-time)
  /// 
  /// Use this when you don't need real-time updates
  Future<List<UserItem>> getAllItems({
    String? category,
    bool? isCompleted,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _itemsCollection;

      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      if (isCompleted != null) {
        query = query.where('isCompleted', isEqualTo: isCompleted);
      }

      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return UserItem.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all items: $e');
    }
  }

  /// Search items by title or description
  /// 
  /// Note: Firestore doesn't support full-text search natively,
  /// so this performs client-side filtering. For production apps,
  /// consider using Algolia or Elasticsearch.
  Future<List<UserItem>> searchItems(String query) async {
    try {
      final allItems = await getAllItems();
      final lowercaseQuery = query.toLowerCase();

      return allItems.where((item) {
        return item.title.toLowerCase().contains(lowercaseQuery) ||
            item.description.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search items: $e');
    }
  }

  // ==================== UPDATE ====================

  /// Update an existing item
  /// 
  /// Only updates the fields that are provided (non-null)
  /// Automatically sets the updatedAt timestamp
  /// 
  /// Example:
  /// ```dart
  /// await crudService.updateItem(
  ///   itemId: 'abc123',
  ///   title: 'Updated Title',
  ///   isCompleted: true,
  /// );
  /// ```
  Future<void> updateItem({
    required String itemId,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (category != null) updates['category'] = category;
      if (isCompleted != null) updates['isCompleted'] = isCompleted;

      await _itemsCollection.doc(itemId).update(updates);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  /// Toggle the completion status of an item
  /// 
  /// Convenience method for marking items as done/undone
  Future<void> toggleItemCompletion(String itemId, bool currentStatus) async {
    try {
      await _itemsCollection.doc(itemId).update({
        'isCompleted': !currentStatus,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to toggle item completion: $e');
    }
  }

  /// Update multiple items in a batch operation
  Future<void> updateItemsBatch(List<String> itemIds, Map<String, dynamic> updates) async {
    try {
      final batch = _firestore.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final itemId in itemIds) {
        final docRef = _itemsCollection.doc(itemId);
        batch.update(docRef, {
          ...updates,
          'updatedAt': now,
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to update items in batch: $e');
    }
  }

  // ==================== DELETE ====================

  /// Delete a single item by ID
  /// 
  /// Example:
  /// ```dart
  /// await crudService.deleteItem('abc123');
  /// ```
  Future<void> deleteItem(String itemId) async {
    try {
      await _itemsCollection.doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  /// Delete multiple items in a batch operation
  /// 
  /// More efficient than deleting items one by one
  Future<void> deleteItemsBatch(List<String> itemIds) async {
    try {
      final batch = _firestore.batch();

      for (final itemId in itemIds) {
        final docRef = _itemsCollection.doc(itemId);
        batch.delete(docRef);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete items in batch: $e');
    }
  }

  /// Delete all completed items for the current user
  /// 
  /// Useful for "Clear Completed" functionality
  Future<int> deleteCompletedItems() async {
    try {
      final completedItems = await getAllItems(isCompleted: true);
      final itemIds = completedItems.map((item) => item.id).toList();

      if (itemIds.isEmpty) return 0;

      await deleteItemsBatch(itemIds);
      return itemIds.length;
    } catch (e) {
      throw Exception('Failed to delete completed items: $e');
    }
  }

  /// Delete all items for the current user
  /// 
  /// ⚠️ WARNING: This is a destructive operation!
  /// Use with caution and always confirm with the user first.
  Future<int> deleteAllItems() async {
    try {
      final allItems = await getAllItems();
      final itemIds = allItems.map((item) => item.id).toList();

      if (itemIds.isEmpty) return 0;

      await deleteItemsBatch(itemIds);
      return itemIds.length;
    } catch (e) {
      throw Exception('Failed to delete all items: $e');
    }
  }

  // ==================== STATISTICS ====================

  /// Get statistics about user's items
  Future<Map<String, dynamic>> getItemStatistics() async {
    try {
      final allItems = await getAllItems();

      final totalCount = allItems.length;
      final completedCount = allItems.where((item) => item.isCompleted).length;
      final activeCount = totalCount - completedCount;

      // Group by category
      final Map<String, int> categoryCount = {};
      for (final item in allItems) {
        if (item.category != null) {
          categoryCount[item.category!] = (categoryCount[item.category!] ?? 0) + 1;
        }
      }

      return {
        'total': totalCount,
        'completed': completedCount,
        'active': activeCount,
        'categories': categoryCount,
      };
    } catch (e) {
      throw Exception('Failed to get statistics: $e');
    }
  }

  /// Check if the user is authenticated
  bool get isUserAuthenticated => _auth.currentUser != null;

  /// Get the current user's email (if available)
  String? get currentUserEmail => _auth.currentUser?.email;
}
