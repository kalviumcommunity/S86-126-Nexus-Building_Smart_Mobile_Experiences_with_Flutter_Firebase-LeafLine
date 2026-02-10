import 'package:flutter/material.dart';

/// Comprehensive demo of BottomNavigationBar implementation
/// Shows three different approaches: Basic, PageView, and IndexedStack
class TabNavigationDemoScreen extends StatelessWidget {
  const TabNavigationDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab Navigation Demos'),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 24),
          _buildDemoCard(
            context,
            title: 'Basic BottomNavigationBar',
            description: 'Simple tab switching with state management',
            icon: Icons.tab,
            color: Colors.blue,
            onTap: () => Navigator.pushNamed(context, '/basicTabNavigation'),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            title: 'PageView Navigation',
            description: 'Smooth transitions with swipe gestures',
            icon: Icons.swipe,
            color: Colors.purple,
            onTap: () => Navigator.pushNamed(context, '/pageViewNavigation'),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            title: 'IndexedStack Navigation',
            description: 'State preservation across tabs',
            icon: Icons.layers,
            color: Colors.teal,
            onTap: () => Navigator.pushNamed(context, '/indexedStackNavigation'),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            title: 'Material 3 NavigationBar',
            description: 'Modern Material Design 3 navigation',
            icon: Icons.navigation,
            color: Colors.orange,
            onTap: () => Navigator.pushNamed(context, '/material3Navigation'),
          ),
          const SizedBox(height: 24),
          _buildBestPracticesCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.navigation, color: Colors.blue.shade700, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tab-Based Navigation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Learn different approaches to implementing bottom navigation in Flutter. '
              'Each demo showcases a different technique with its own benefits.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestPracticesCard() {
    return Card(
      elevation: 0,
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.green.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Best Practices',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBestPracticeItem('Use 3-5 tabs for optimal UX'),
            _buildBestPracticeItem('Keep labels short and clear'),
            _buildBestPracticeItem('Use consistent, recognizable icons'),
            _buildBestPracticeItem('Preserve state when switching tabs'),
            _buildBestPracticeItem('Avoid destructive actions in navigation'),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPracticeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
