import 'package:flutter/material.dart';

/// Basic BottomNavigationBar implementation
/// Simple approach with direct screen switching
class BasicTabNavigationScreen extends StatefulWidget {
  const BasicTabNavigationScreen({super.key});

  @override
  State<BasicTabNavigationScreen> createState() => _BasicTabNavigationScreenState();
}

class _BasicTabNavigationScreenState extends State<BasicTabNavigationScreen> {
  int _currentIndex = 0;

  // Define screens outside build() to avoid recreation
  static const List<Widget> _screens = [
    TabHomeScreen(),
    TabSearchScreen(),
    TabNotificationsScreen(),
    TabProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Tab Navigation'),
        elevation: 2,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Sample Tab Screens
class TabHomeScreen extends StatelessWidget {
  const TabHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 80, color: Colors.blue.shade300),
          const SizedBox(height: 16),
          const Text(
            'Home Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Basic BottomNavigationBar Demo',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class TabSearchScreen extends StatefulWidget {
  const TabSearchScreen({super.key});

  @override
  State<TabSearchScreen> createState() => _TabSearchScreenState();
}

class _TabSearchScreenState extends State<TabSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.purple.shade300),
          const SizedBox(height: 16),
          const Text(
            'Search Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Note: Input state is preserved when switching tabs',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TabNotificationsScreen extends StatelessWidget {
  const TabNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 40),
        Center(
          child: Icon(Icons.notifications, size: 80, color: Colors.orange.shade300),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Notifications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        _buildNotificationCard(
          'New Message',
          'You have a new message from John',
          Icons.message,
          Colors.blue,
        ),
        _buildNotificationCard(
          'Update Available',
          'A new version is available',
          Icons.system_update,
          Colors.green,
        ),
        _buildNotificationCard(
          'Reminder',
          'Complete your profile',
          Icons.alarm,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildNotificationCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      ),
    );
  }
}

class TabProfileScreen extends StatelessWidget {
  const TabProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 40),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, size: 50, color: Colors.blue.shade700),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'john.doe@example.com',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 32),
        _buildProfileOption(Icons.edit, 'Edit Profile'),
        _buildProfileOption(Icons.settings, 'Settings'),
        _buildProfileOption(Icons.privacy_tip, 'Privacy'),
        _buildProfileOption(Icons.help, 'Help & Support'),
        _buildProfileOption(Icons.logout, 'Logout', isDestructive: true),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {bool isDestructive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.blue.shade700,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      ),
    );
  }
}
