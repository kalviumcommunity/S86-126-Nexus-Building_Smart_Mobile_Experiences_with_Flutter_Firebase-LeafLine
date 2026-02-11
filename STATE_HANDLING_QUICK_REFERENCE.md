# 📊 State Handling - Quick Reference

## 🚀 Quick Start

### Import
```dart
import 'widgets/loading_state_widget.dart';
import 'widgets/error_state_widget.dart';
import 'widgets/empty_state_widget.dart';
```

---

## 🔄 Loading States

### Basic Usage
```dart
// Simple
LoadingStateWidget()

// With message
LoadingStateWidget(message: 'Loading...')

// Linear
LoadingStateWidget(style: LoadingStyle.linear)

// Skeleton
ListSkeletonLoader(itemCount: 5)
```

### All Loading Styles
- `LoadingStyle.circular` - Default circular spinner
- `LoadingStyle.linear` - Horizontal progress bar
- `LoadingStyle.adaptive` - Platform-specific
- `LoadingStyle.custom` - Custom animation

---

## ❌ Error States

### Quick Templates
```dart
// Network error
ErrorStateWidget.network(onRetry: _retry)

// Permission error
ErrorStateWidget.permission(onRetry: _retry)

// Not found
ErrorStateWidget.notFound()

// Generic
ErrorStateWidget.generic(
  message: 'Something went wrong',
  onRetry: _retry,
)

// Compact (inline)
CompactErrorWidget(
  message: 'Failed to load',
  onRetry: _retry,
)
```

---

## 📭 Empty States

### Quick Templates
```dart
// Empty list
EmptyStateWidget.list(onAction: _addItem)

// No search results
EmptyStateWidget.search(query: 'keyword')

// No favorites
EmptyStateWidget.favorites(onBrowse: _browse)

// No notifications
EmptyStateWidget.notifications()

// Offline
EmptyStateWidget.offline(onRetry: _retry)

// Completed
EmptyStateWidget.completed()

// Compact (inline)
CompactEmptyWidget(message: 'No items')
```

---

## 🔄 Complete FutureBuilder Pattern

```dart
FutureBuilder<List<Data>>(
  future: loadData(),
  builder: (context, snapshot) {
    // Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingStateWidget(
        message: 'Loading...',
      );
    }

    // Error
    if (snapshot.hasError) {
      return ErrorStateWidget.generic(
        message: 'Failed to load',
        onRetry: () => setState(() {}),
      );
    }

    // Empty
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return EmptyStateWidget.list(
        onAction: _add,
      );
    }

    // Success
    final data = snapshot.data!;
    return ListView.builder(/* ... */);
  },
)
```

---

## 🔄 Complete StreamBuilder Pattern

```dart
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('items').snapshots(),
  builder: (context, snapshot) {
    // Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingStateWidget();
    }

    // Error
    if (snapshot.hasError) {
      return ErrorStateWidget.network(
        onRetry: () => setState(() {}),
      );
    }

    // Empty
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return EmptyStateWidget.list();
    }

    // Success
    final docs = snapshot.data!.docs;
    return ListView(/* ... */);
  },
)
```

---

## 🎨 Customization

### Custom Colors
```dart
LoadingStateWidget(
  color: Colors.purple,
  size: 60,
)
```

### Custom Icons
```dart
EmptyStateWidget(
  icon: Icons.shopping_cart,
  iconColor: Colors.orange,
  iconSize: 100,
)
```

### Custom Messages
```dart
ErrorStateWidget(
  title: 'Upload Failed',
  message: 'Could not save your changes',
  icon: Icons.cloud_off,
  onRetry: _retry,
)
```

---

## 📋 Checklist

**Before deploying, ensure:**
- [ ] All async operations have loading states
- [ ] All errors show user-friendly messages
- [ ] All empty states have helpful guidance
- [ ] Retry buttons work correctly
- [ ] Technical errors are logged (not shown to users)
- [ ] Loading states appear instantly
- [ ] Empty states have CTAs when appropriate

---

## 🎯 Common Patterns

### Pattern 1: Data List
```dart
if (loading) return LoadingStateWidget();
if (error) return ErrorStateWidget.network(onRetry: _retry);
if (empty) return EmptyStateWidget.list(onAction: _add);
return ListView(children: items);
```

### Pattern 2: Search Results
```dart
if (loading) return ListSkeletonLoader();
if (error) return ErrorStateWidget.generic(onRetry: _retry);
if (empty) return EmptyStateWidget.search(query: query);
return GridView(children: results);
```

### Pattern 3: User Profile
```dart
if (loading) return LoadingStateWidget(message: 'Loading profile...');
if (error) return ErrorStateWidget.permission();
if (empty) return EmptyStateWidget.notFound();
return ProfileView(user: user);
```

---

## 🚨 Common Mistakes

### ❌ Don't
```dart
// No loading state
if (snapshot.hasData) return ListView(...);
return SizedBox(); // Blank!

// Raw error
if (error) return Text(error.toString()); // Technical!

// No guidance
if (empty) return Text('Empty'); // Unhelpful!
```

### ✅ Do
```dart
// Proper states
if (loading) return LoadingStateWidget();
if (error) return ErrorStateWidget.generic(onRetry: _retry);
if (empty) return EmptyStateWidget.list(onAction: _add);
return ListView(...);
```

---

## 📱 Demo Navigation

```dart
// View all examples
Navigator.pushNamed(context, '/stateHandling');
```

---

## 📚 Resources

- **Full Guide**: [STATE_HANDLING_GUIDE.md](STATE_HANDLING_GUIDE.md)
- **Summary**: [STATE_HANDLING_SUMMARY.md](STATE_HANDLING_SUMMARY.md)
- **Demo Screen**: `/stateHandling` route

---

## ⚡ Pro Tips

1. Use skeleton loaders for lists (better UX)
2. Log errors but show friendly messages
3. Provide retry buttons for network errors
4. Add CTAs in empty states
5. Test with slow network
6. Handle all ConnectionState values
7. Use `const` for static widgets
8. Customize for your brand colors

---

**Happy Coding! 🎉**
