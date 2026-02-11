# 📊 State Handling Guide - Loading, Error & Empty States

## Overview

Professional mobile applications must handle three essential UI states gracefully:

1. **Loading State** - When data is being fetched or an operation is in progress
2. **Error State** - When something fails (network error, Firebase error, invalid input)
3. **Empty State** - When there is no content to show yet

This guide demonstrates how to implement these states properly using reusable widgets and best practices.

---

## 🎯 Why State Handling Matters

### User Experience Benefits
- ✅ Prevents UI from appearing "frozen" during operations
- ✅ Helps users understand what's happening behind the scenes
- ✅ Reduces confusion when data is empty or missing
- ✅ Improves perceived performance and reliability
- ✅ Encourages good UX patterns (retry buttons, helpful messages)

### Technical Benefits
- ✅ Reusable components across the app
- ✅ Consistent error handling
- ✅ Easier debugging and maintenance
- ✅ Better code organization

---

## 📦 Implementation Structure

### File Organization

```
lib/
├── widgets/
│   ├── loading_state_widget.dart       # Loading indicators
│   ├── error_state_widget.dart         # Error displays
│   └── empty_state_widget.dart         # Empty state screens
└── screens/
    └── state_handling_demo_screen.dart # Interactive demo
```

---

## 🔄 Loading States

### 1. Basic Loading Widget

The `LoadingStateWidget` provides multiple loading styles:

```dart
// Simple circular loader
LoadingStateWidget()

// With message
LoadingStateWidget(
  message: 'Loading your data...',
)

// Linear progress
LoadingStateWidget(
  style: LoadingStyle.linear,
  message: 'Please wait...',
)

// Custom styled
LoadingStateWidget(
  style: LoadingStyle.custom,
  size: 60,
  color: Colors.blue,
)
```

### 2. Skeleton Loaders

Skeleton loaders provide better perceived performance with shimmer effects:

```dart
// Single skeleton
SkeletonLoader(
  width: 200,
  height: 16,
  borderRadius: BorderRadius.circular(8),
)

// List skeleton
ListSkeletonLoader(
  itemCount: 5,
  itemHeight: 80,
)
```

### 3. Loading Styles

Available loading styles:
- **circular** - Default circular progress indicator
- **linear** - Horizontal progress bar
- **adaptive** - Platform-specific loader
- **custom** - Custom double-ring animation

### Usage Example

```dart
FutureBuilder<List<Item>>(
  future: fetchItems(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingStateWidget(
        message: 'Fetching items...',
      );
    }
    // Handle other states...
  },
)
```

---

## ❌ Error States

### 1. Error Widget Types

The `ErrorStateWidget` provides multiple error templates:

#### Network Error
```dart
ErrorStateWidget.network(
  onRetry: () {
    // Retry logic
  },
)
```

#### Permission Error
```dart
ErrorStateWidget.permission(
  message: 'Custom permission message',
  onRetry: () {
    // Request permissions
  },
)
```

#### Not Found Error
```dart
ErrorStateWidget.notFound(
  message: 'The item you\'re looking for doesn\'t exist.',
)
```

#### Generic Error
```dart
ErrorStateWidget.generic(
  message: 'An unexpected error occurred',
  technicalDetails: error.toString(),
  onRetry: () {
    // Retry action
  },
)
```

### 2. Compact Error Widget

For inline error displays:

```dart
CompactErrorWidget(
  message: 'Failed to load data',
  onRetry: () {
    // Retry logic
  },
)
```

### 3. Error Best Practices

#### ✅ DO:
- Show user-friendly messages
- Provide retry buttons when applicable
- Log technical details for debugging
- Offer help or troubleshooting tips
- Use appropriate icons and colors

#### ❌ DON'T:
- Expose raw exceptions to users
- Show stack traces in production
- Use technical jargon
- Leave users with no action to take
- Ignore error recovery

### Usage Example

```dart
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('items').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ErrorStateWidget.generic(
        message: 'Failed to load items',
        technicalDetails: snapshot.error.toString(),
        onRetry: () {
          setState(() {
            // Trigger rebuild
          });
        },
      );
    }
    // Handle other states...
  },
)
```

---

## 📭 Empty States

### 1. Empty Widget Types

The `EmptyStateWidget` provides contextual empty screens:

#### Empty List
```dart
EmptyStateWidget.list(
  title: 'No Items Yet',
  message: 'Get started by adding your first item.',
  actionLabel: 'Add Item',
  onAction: () {
    // Navigate to add screen
  },
)
```

#### No Search Results
```dart
EmptyStateWidget.search(
  query: searchQuery,
  onClear: () {
    // Clear search
  },
)
```

#### No Favorites
```dart
EmptyStateWidget.favorites(
  onBrowse: () {
    // Navigate to browse
  },
)
```

#### No Notifications
```dart
EmptyStateWidget.notifications()
```

#### Offline State
```dart
EmptyStateWidget.offline(
  onRetry: () {
    // Retry connection
  },
)
```

#### All Completed
```dart
EmptyStateWidget.completed()
```

### 2. Custom Empty State

```dart
EmptyStateWidget(
  title: 'Custom Title',
  message: 'Your custom message here',
  icon: Icons.custom_icon,
  iconColor: Colors.purple,
  actionLabel: 'Take Action',
  onAction: () {
    // Custom action
  },
)
```

### 3. Compact Empty Widget

For smaller empty displays:

```dart
CompactEmptyWidget(
  message: 'No items to display',
  icon: Icons.inbox,
)
```

### 4. Animated Empty State

Add smooth animations:

```dart
AnimatedEmptyState(
  child: EmptyStateWidget.list(
    onAction: () {},
  ),
)
```

### Usage Example

```dart
FutureBuilder<List<Item>>(
  future: fetchItems(),
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return EmptyStateWidget.list(
        title: 'No Items',
        message: 'Start adding items to see them here.',
        actionLabel: 'Add First Item',
        onAction: () {
          Navigator.push(/* ... */);
        },
      );
    }
    // Show data...
  },
)
```

---

## 🔄 Async Patterns

### 1. FutureBuilder Pattern

```dart
FutureBuilder<List<Data>>(
  future: loadData(),
  builder: (context, snapshot) {
    // Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingStateWidget(
        message: 'Loading data...',
      );
    }

    // Error
    if (snapshot.hasError) {
      return ErrorStateWidget.generic(
        message: 'Failed to load data',
        technicalDetails: snapshot.error.toString(),
        onRetry: _retryLoad,
      );
    }

    // Empty
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return EmptyStateWidget.list(
        onAction: _addItem,
      );
    }

    // Success - Show data
    final data = snapshot.data!;
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(data[index].name));
      },
    );
  },
)
```

### 2. StreamBuilder Pattern

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('items')
      .snapshots(),
  builder: (context, snapshot) {
    // Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingStateWidget(
        message: 'Connecting...',
      );
    }

    // Error
    if (snapshot.hasError) {
      return ErrorStateWidget.network(
        onRetry: () {
          setState(() {}); // Trigger rebuild
        },
      );
    }

    // Empty
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return EmptyStateWidget.list(
        title: 'No Data',
        message: 'Start adding items to see them here.',
      );
    }

    // Success
    final docs = snapshot.data!.docs;
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(docs[index]['name']),
        );
      },
    );
  },
)
```

---

## 📱 Complete Example

Here's a complete example combining all state types:

```dart
class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  late Future<List<Item>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<List<Item>> _loadData() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Fetch from API/Firebase
      final snapshot = await FirebaseFirestore.instance
          .collection('items')
          .get();
      
      return snapshot.docs
          .map((doc) => Item.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  void _retry() {
    setState(() {
      _dataFuture = _loadData();
    });
  }

  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddItemScreen(),
      ),
    ).then((_) => _retry());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retry,
          ),
        ],
      ),
      body: FutureBuilder<List<Item>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingStateWidget(
              message: 'Loading items...',
              style: LoadingStyle.circular,
            );
          }

          // Error State
          if (snapshot.hasError) {
            return ErrorStateWidget.generic(
              message: 'Failed to load items',
              technicalDetails: snapshot.error.toString(),
              onRetry: _retry,
            );
          }

          // Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return AnimatedEmptyState(
              child: EmptyStateWidget.list(
                title: 'No Items Yet',
                message: 'Add your first item to get started',
                actionLabel: 'Add Item',
                onAction: _addItem,
              ),
            );
          }

          // Success State - Show Data
          final items = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(item.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteItem(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(id)
          .delete();
      _retry();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
```

---

## 🎨 Customization

### Custom Colors

```dart
LoadingStateWidget(
  color: theme.colorScheme.secondary,
  message: 'Processing...',
)
```

### Custom Icons

```dart
EmptyStateWidget(
  icon: Icons.shopping_bag,
  iconColor: Colors.orange,
  iconSize: 100,
  title: 'Cart is Empty',
)
```

### Custom Actions

```dart
EmptyStateWidget(
  customAction: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(onPressed: () {}, child: Text('Action 1')),
      SizedBox(width: 16),
      OutlinedButton(onPressed: () {}, child: Text('Action 2')),
    ],
  ),
)
```

---

## ⚠️ Common Mistakes

### ❌ Don't Do This

```dart
// Bad: No loading state
StreamBuilder(
  stream: stream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView(...);
    }
    return SizedBox(); // Blank screen while loading!
  },
)

// Bad: Raw error messages
if (snapshot.hasError) {
  return Text(snapshot.error.toString()); // Technical error!
}

// Bad: Unhelpful empty state
if (data.isEmpty) {
  return Text('Empty'); // No guidance for user
}
```

### ✅ Do This Instead

```dart
// Good: Handle all states
StreamBuilder(
  stream: stream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingStateWidget();
    }
    
    if (snapshot.hasError) {
      return ErrorStateWidget.generic(
        onRetry: () => setState(() {}),
      );
    }
    
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return EmptyStateWidget.list(onAction: _addItem);
    }
    
    return ListView(...);
  },
)
```

---

## 🔍 Debugging Tips

### Enable Technical Details in Development

```dart
ErrorStateWidget.generic(
  message: 'Something went wrong',
  technicalDetails: kDebugMode ? error.toString() : null,
  showTechnicalDetails: kDebugMode,
)
```

### Log Errors Properly

```dart
try {
  await performOperation();
} catch (e, stackTrace) {
  debugPrint('Error: $e');
  debugPrint('Stack trace: $stackTrace');
  
  if (mounted) {
    // Show error to user
  }
}
```

---

## 📚 Additional Resources

- **FutureBuilder Docs**: https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
- **StreamBuilder Docs**: https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html
- **Material Design Guidelines**: https://m3.material.io/components/progress-indicators
- **Error Handling**: https://docs.flutter.dev/testing/errors

---

## 🚀 Quick Start

1. **Import the widgets**:
```dart
import 'widgets/loading_state_widget.dart';
import 'widgets/error_state_widget.dart';
import 'widgets/empty_state_widget.dart';
```

2. **Use in your StreamBuilder/FutureBuilder**:
```dart
// Loading
return const LoadingStateWidget();

// Error
return ErrorStateWidget.network(onRetry: _retry);

// Empty
return EmptyStateWidget.list(onAction: _add);
```

3. **Test all states** in the demo screen:
```dart
Navigator.pushNamed(context, '/stateHandling');
```

---

## ✨ Best Practices Summary

1. **Always handle all three states**: Loading, Error, Empty
2. **Use descriptive messages**: Help users understand what's happening
3. **Provide actions**: Retry buttons, CTAs, navigation options
4. **Log errors properly**: Debug technical issues without showing raw errors to users
5. **Test edge cases**: Slow network, no network, permission denied, etc.
6. **Use consistent styling**: Reuse widgets across your app
7. **Add animations**: Smooth transitions improve perceived performance
8. **Consider accessibility**: Ensure screen readers work with all states

---

**Happy coding! 🎉** Your app now has professional state handling that users will appreciate.
