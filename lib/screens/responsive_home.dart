import 'package:flutter/material.dart';
import 'login_screen.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // EXPLICIT breakpoint for assignment clarity
            if (constraints.maxWidth < 600) {
              return _buildResponsiveLayout(context, constraints, false);
            } else {
              return _buildResponsiveLayout(context, constraints, true);
            }
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    BoxConstraints constraints,
    bool isTablet,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isLandscape = screenWidth > screenHeight;

    return Column(
      children: [
        _buildHeader(context, screenWidth, isTablet),
        Expanded(
          child: _buildMainContent(
            context,
            screenWidth,
            screenHeight,
            isTablet,
            isLandscape,
          ),
        ),
        _buildFooter(context, screenWidth),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: isTablet ? 24 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LeafLine',
                style: TextStyle(
                  fontSize: isTablet ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Smart Mobile Experience',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Icon(
            Icons.eco,
            size: isTablet ? 40 : 32,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    bool isTablet,
    bool isLandscape,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(isTablet),
          const SizedBox(height: 24),
          Text(
            'Features',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _buildFeatureCards(isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to LeafLine',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Experience smart mobile interfaces that adapt to any device using Flutter and Firebase.',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureCards(bool isTablet) {
    final features = [
      {'icon': Icons.devices, 'title': 'Responsive'},
      {'icon': Icons.speed, 'title': 'Fast'},
      {'icon': Icons.security, 'title': 'Secure'},
      {'icon': Icons.cloud_sync, 'title': 'Sync'},
    ];

    return features.map((feature) {
      return Container(
        width: isTablet ? 200 : 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(feature['icon'] as IconData, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              feature['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildFooter(BuildContext context, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context,
              'Get Started',
              Icons.play_arrow,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              'Learn More',
              Icons.info,
              Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        if (text == 'Get Started') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text('About LeafLine'),
              content: Text(
                'LeafLine helps users manage plant care using responsive Flutter interfaces.',
              ),
            ),
          );
        }
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
