import 'package:flutter/material.dart';

/// Material Design 3 NavigationBar implementation
/// Modern, adaptive navigation with better accessibility
class Material3NavigationScreen extends StatefulWidget {
  const Material3NavigationScreen({super.key});

  @override
  State<Material3NavigationScreen> createState() => _Material3NavigationScreenState();
}

class _Material3NavigationScreenState extends State<Material3NavigationScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    Material3HomeTab(),
    Material3LibraryTab(),
    Material3CommunityTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Navigation'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Chip(
                label: const Text('Material 3', style: TextStyle(fontSize: 11)),
                backgroundColor: Colors.orange.shade100,
                avatar: const Icon(Icons.new_releases, size: 16),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

// Material 3 Home Tab
class Material3HomeTab extends StatelessWidget {
  const Material3HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Material 3 NavigationBar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Modern Material Design 3 styling\n'
                  '• Better accessibility and touch targets\n'
                  '• Adaptive colors based on theme\n'
                  '• Smooth indicator animations',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Trending Now',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildVideoCard(
          context,
          'Flutter 3.0 - What\'s New',
          'Flutter Team • 1.2M views',
          Colors.blue,
          Icons.flutter_dash,
        ),
        _buildVideoCard(
          context,
          'Building Beautiful UIs',
          'UI/UX Channel • 856K views',
          Colors.purple,
          Icons.palette,
        ),
        _buildVideoCard(
          context,
          'State Management Guide',
          'Code Academy • 645K views',
          Colors.teal,
          Icons.architecture,
        ),
      ],
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// Material 3 Library Tab
class Material3LibraryTab extends StatelessWidget {
  const Material3LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              const Text(
                'Your Library',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Playlists',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final colors = [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal,
                ];
                final icons = [
                  Icons.favorite,
                  Icons.music_note,
                  Icons.video_library,
                  Icons.watch_later,
                  Icons.trending_up,
                  Icons.new_releases,
                ];
                final titles = [
                  'Favorites',
                  'Recently Played',
                  'Watch Later',
                  'History',
                  'Trending',
                  'New Releases',
                ];

                return Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors[index % colors.length],
                            colors[index % colors.length].withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icons[index % icons.length],
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            titles[index % titles.length],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(index + 1) * 12} videos',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: 6,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }
}

// Material 3 Community Tab
class Material3CommunityTab extends StatelessWidget {
  const Material3CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        const Text(
          'Community',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildCommunityPost(
          context,
          name: 'Sarah Johnson',
          time: '2 hours ago',
          content: 'Just published a new tutorial on Flutter animations! Check it out 🚀',
          likes: 234,
          comments: 45,
          color: Colors.blue,
        ),
        _buildCommunityPost(
          context,
          name: 'Mike Chen',
          time: '5 hours ago',
          content: 'Working on a new open-source project. Contributions welcome!',
          likes: 189,
          comments: 32,
          color: Colors.green,
        ),
        _buildCommunityPost(
          context,
          name: 'Emily Davis',
          time: '1 day ago',
          content: 'Material 3 design is absolutely gorgeous. Loving the new components!',
          likes: 512,
          comments: 78,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildCommunityPost(
    BuildContext context, {
    required String name,
    required String time,
    required String content,
    required int likes,
    required int comments,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Text(
                    name[0],
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildActionButton(Icons.thumb_up_outlined, '$likes'),
                const SizedBox(width: 24),
                _buildActionButton(Icons.comment_outlined, '$comments'),
                const SizedBox(width: 24),
                _buildActionButton(Icons.share_outlined, 'Share'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
