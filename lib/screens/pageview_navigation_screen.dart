import 'package:flutter/material.dart';

/// PageView-based navigation with smooth transitions
/// Allows swipe gestures and animated page changes
class PageViewNavigationScreen extends StatefulWidget {
  const PageViewNavigationScreen({super.key});

  @override
  State<PageViewNavigationScreen> createState() => _PageViewNavigationScreenState();
}

class _PageViewNavigationScreenState extends State<PageViewNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageView Navigation'),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Chip(
                label: const Text('Swipe enabled', style: TextStyle(fontSize: 11)),
                backgroundColor: Colors.green.shade100,
                avatar: const Icon(Icons.swipe, size: 16),
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          PageViewHomeTab(),
          PageViewExploreTab(),
          PageViewFavoritesTab(),
          PageViewSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// PageView Tab Screens
class PageViewHomeTab extends StatelessWidget {
  const PageViewHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          color: Colors.purple.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.purple.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'PageView Navigation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Swipe left or right to navigate\n'
                  '• Smooth animated transitions\n'
                  '• Better performance than recreating widgets\n'
                  '• Natural gesture-based UX',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildActivityCard('Completed Task', 'Design review meeting', Icons.check_circle, Colors.green),
        _buildActivityCard('New Comment', 'On your latest post', Icons.comment, Colors.blue),
        _buildActivityCard('Upcoming Event', 'Team standup at 10 AM', Icons.event, Colors.orange),
      ],
    );
  }

  Widget _buildActivityCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class PageViewExploreTab extends StatefulWidget {
  const PageViewExploreTab({super.key});

  @override
  State<PageViewExploreTab> createState() => _PageViewExploreTabState();
}

class _PageViewExploreTabState extends State<PageViewExploreTab> {
  final List<String> _categories = ['All', 'Design', 'Development', 'Business', 'Marketing'];
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Explore',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategory == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_categories[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = index;
                    });
                  },
                  selectedColor: Colors.purple,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      color: Colors.primaries[index % Colors.primaries.length].shade100,
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.primaries[index % Colors.primaries.length],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _categories[_selectedCategory],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PageViewFavoritesTab extends StatelessWidget {
  const PageViewFavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 100, color: Colors.pink.shade200),
          const SizedBox(height: 24),
          const Text(
            'Your Favorites',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Items you love will appear here',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.search),
            label: const Text('Browse Items'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class PageViewSettingsTab extends StatefulWidget {
  const PageViewSettingsTab({super.key});

  @override
  State<PageViewSettingsTab> createState() => _PageViewSettingsTabState();
}

class _PageViewSettingsTabState extends State<PageViewSettingsTab> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        const Text(
          'Settings',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        const Text(
          'Preferences',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive updates and alerts'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
          activeColor: Colors.purple,
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable dark theme'),
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
          activeColor: Colors.purple,
        ),
        const SizedBox(height: 24),
        const Text(
          'Account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildSettingsOption(Icons.person, 'Edit Profile'),
        _buildSettingsOption(Icons.lock, 'Change Password'),
        _buildSettingsOption(Icons.privacy_tip, 'Privacy Settings'),
        const SizedBox(height: 24),
        const Text(
          'Support',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildSettingsOption(Icons.help, 'Help Center'),
        _buildSettingsOption(Icons.feedback, 'Send Feedback'),
        _buildSettingsOption(Icons.info, 'About'),
      ],
    );
  }

  Widget _buildSettingsOption(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        onTap: () {},
      ),
    );
  }
}
