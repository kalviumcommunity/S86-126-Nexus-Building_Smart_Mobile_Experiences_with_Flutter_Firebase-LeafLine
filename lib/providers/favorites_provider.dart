import 'package:flutter/foundation.dart';

/// State provider for managing favorites across multiple screens
/// 
/// Demonstrates multi-screen shared state using Provider pattern
/// This is a simple example showing how state can be accessed and
/// modified from anywhere in the app.
class FavoritesProvider with ChangeNotifier {
  final List<String> _favoriteItems = [];
  
  // Getters
  List<String> get favoriteItems => List.unmodifiable(_favoriteItems);
  int get favoriteCount => _favoriteItems.length;
  bool get hasFavorites => _favoriteItems.isNotEmpty;

  /// Add an item to favorites
  void addFavorite(String itemId) {
    if (!_favoriteItems.contains(itemId)) {
      _favoriteItems.add(itemId);
      notifyListeners();
    }
  }

  /// Remove an item from favorites
  void removeFavorite(String itemId) {
    if (_favoriteItems.remove(itemId)) {
      notifyListeners();
    }
  }

  /// Toggle favorite status
  void toggleFavorite(String itemId) {
    if (_favoriteItems.contains(itemId)) {
      removeFavorite(itemId);
    } else {
      addFavorite(itemId);
    }
  }

  /// Check if an item is favorited
  bool isFavorite(String itemId) {
    return _favoriteItems.contains(itemId);
  }

  /// Clear all favorites
  void clearFavorites() {
    _favoriteItems.clear();
    notifyListeners();
  }
}
