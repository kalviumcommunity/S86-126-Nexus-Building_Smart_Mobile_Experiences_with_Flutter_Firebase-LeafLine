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
            return _buildResponsiveLayout(context, constraints);
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, BoxConstraints constraints) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
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
        _buildFooter(context, screenWidth, isTablet),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth, bool isTablet) {
    final titleFontSize = isTablet ? 28.0 : 24.0;
    final subtitleFontSize = isTablet ? 16.0 : 14.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: isTablet ? 24.0 : 20.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Smart Mobile Experience',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: Colors.white.withOpacity(0.9),
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
    final padding = screenWidth * 0.05;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
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

  Widget _buildFooter(BuildContext context, double screenWidth, bool isTablet) {
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
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              'Contact Us',
              Icons.contact_mail,
              Colors.green,
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
       debugPrint('Button clicked: $text');
        if (text == 'Get Started') {
          debugPrint('Navigating to LoginScreen');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (text == 'Learn More') {
          debugPrint('Opening Learn More dialog');
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text('About LeafLine'),
              content: Text('LeafLine uses Flutter and Firebase to build smart, scalable mobile apps.'),
            ),
          );
        } else {
          debugPrint('Showing Contact snackbar');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact feature coming soon')),
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
