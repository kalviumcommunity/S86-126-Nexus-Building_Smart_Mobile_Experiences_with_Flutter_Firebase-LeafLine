/// Data model for user items in CRUD operations
/// 
/// Represents an item that belongs to a specific user and is stored
/// in Firestore under /users/{uid}/items/{itemId}

class UserItem {
  /// Unique identifier for this item (Firestore document ID)
  final String id;

  /// Title or name of the item
  final String title;

  /// Detailed description of the item
  final String description;

  /// Timestamp when the item was created (milliseconds since epoch)
  final int createdAt;

  /// Timestamp when the item was last updated (optional)
  final int? updatedAt;

  /// Optional category or tag for the item
  final String? category;

  /// Flag to mark item as completed/done (useful for tasks/todos)
  final bool isCompleted;

  const UserItem({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    this.category,
    this.isCompleted = false,
  });

  /// Create a UserItem from Firestore document data
  factory UserItem.fromFirestore(String id, Map<String, dynamic> data) {
    return UserItem(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      createdAt: data['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: data['updatedAt'] as int?,
      category: data['category'] as String?,
      isCompleted: data['isCompleted'] as bool? ?? false,
    );
  }

  /// Convert UserItem to Map for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  /// Create a copy of this UserItem with modified fields
  UserItem copyWith({
    String? id,
    String? title,
    String? description,
    int? createdAt,
    int? updatedAt,
    String? category,
    bool? isCompleted,
  }) {
    return UserItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Get formatted creation date
  DateTime get createdDate => DateTime.fromMillisecondsSinceEpoch(createdAt);

  /// Get formatted update date (if available)
  DateTime? get updatedDate =>
      updatedAt != null ? DateTime.fromMillisecondsSinceEpoch(updatedAt!) : null;

  @override
  String toString() {
    return 'UserItem(id: $id, title: $title, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserItem &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.category == category &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      createdAt,
      updatedAt,
      category,
      isCompleted,
    );
  }
}
