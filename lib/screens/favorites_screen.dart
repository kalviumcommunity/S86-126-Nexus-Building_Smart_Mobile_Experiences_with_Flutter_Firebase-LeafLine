import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/items_provider.dart';

/// Favorites Screen demonstrating multi-screen shared state
/// 
/// This screen reads from FavoritesProvider which is shared
/// with the main CRUD screen, showcasing how state persists
/// across navigation and updates in real-time.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch for changes in both providers
    final favoritesProvider = context.watch<FavoritesProvider>();
    final itemsProvider = context.watch<ItemsProvider>();

    // Get favorite items
    final favoriteItemIds = favoritesProvider.favoriteItems;
    final favoriteItems = itemsProvider.allItems
        .where((item) => favoriteItemIds.contains(item.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        elevation: 2,
        actions: [
          if (favoritesProvider.hasFavorites)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _clearAllFavorites(context),
              tooltip: 'Clear All Favorites',
            ),
        ],
      ),
      body: Column(
        children: [
          // Info card
          if (favoritesProvider.hasFavorites)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.pink.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.pink.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You have ${favoritesProvider.favoriteCount} favorite item${favoritesProvider.favoriteCount == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Favorites list
          Expanded(
            child: favoriteItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the heart icon on items\nto add them to favorites',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteItems.length,
                    itemBuilder: (context, index) {
                      final item = favoriteItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: item.isCompleted
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            child: Icon(
                              item.isCompleted
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color: item.isCompleted
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.category != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '📁 ${item.category}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              favoritesProvider.removeFavorite(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Removed from favorites'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            tooltip: 'Remove from favorites',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _clearAllFavorites(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'Are you sure you want to remove all items from favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FavoritesProvider>().clearFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All favorites cleared'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
