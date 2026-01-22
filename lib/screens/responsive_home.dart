import 'package:flutter/material.dart';

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
        // Header Section
        _buildHeader(context, screenWidth, isTablet),
        
        // Main Content Area
        Expanded(
          child: _buildMainContent(context, screenWidth, screenHeight, isTablet, isLandscape),
        ),
        
        // Footer Section
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
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
                    SizedBox(height: isTablet ? 8 : 4),
                    Text(
                      'Smart Mobile Experience',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.eco,
                size: isTablet ? 40 : 32,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, double screenWidth, double screenHeight, bool isTablet, bool isLandscape) {
    final padding = screenWidth * 0.05;
    
    if (isTablet) {
      return _buildTabletLayout(context, screenWidth, padding);
    } else {
      return _buildPhoneLayout(context, screenWidth, screenHeight, padding, isLandscape);
    }
  }

  Widget _buildTabletLayout(BuildContext context, double screenWidth, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Features Grid
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: _buildFeatureCards(true),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 24),
          
          // Right Column - Stats and Actions
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: _buildStatCards(true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context, double screenWidth, double screenHeight, double padding, bool isLandscape) {
    if (isLandscape) {
      return Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            // Left side - Features (scrollable)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: _buildFeatureCards(false),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Right side - Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: _buildStatCards(false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Portrait mode for phones
      return SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(false),
            
            const SizedBox(height: 24),
            
            // Features Section
            Text(
              'Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _buildFeatureCards(false),
            ),
            
            const SizedBox(height: 24),
            
            // Stats Section
            Text(
              'Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            ..._buildStatCards(false),
          ],
        ),
      );
    }
  }

  Widget _buildWelcomeSection(bool isTablet) {
    final fontSize = isTablet ? 18.0 : 16.0;
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.eco,
                color: Colors.green.shade600,
                size: isTablet ? 32 : 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Welcome to LeafLine',
                  style: TextStyle(
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Experience smart mobile interfaces that adapt to any device. This responsive layout demonstrates how Flutter can create beautiful, adaptive designs for phones and tablets.',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureCards(bool isTablet) {
    final cardData = [
      {'icon': Icons.devices, 'title': 'Responsive', 'subtitle': 'Adaptive layouts'},
      {'icon': Icons.speed, 'title': 'Fast', 'subtitle': 'Optimized performance'},
      {'icon': Icons.security, 'title': 'Secure', 'subtitle': 'Data protection'},
      {'icon': Icons.cloud_sync, 'title': 'Sync', 'subtitle': 'Real-time updates'},
    ];

    return cardData.map((data) {
      return Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              data['icon'] as IconData,
              size: isTablet ? 48 : 40,
              color: Colors.blue.shade600,
            ),
            SizedBox(height: isTablet ? 12 : 8),
            FittedBox(
              child: Text(
                data['title'] as String,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            FittedBox(
              child: Text(
                data['subtitle'] as String,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildStatCards(bool isTablet) {
    final statData = [
      {'title': 'Active Users', 'value': '10.2K', 'change': '+15%', 'color': Colors.green},
      {'title': 'Downloads', 'value': '50.8K', 'change': '+28%', 'color': Colors.blue},
      {'title': 'Rating', 'value': '4.9', 'change': '+0.2', 'color': Colors.orange},
    ];

    return statData.map((data) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] as String,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['value'] as String,
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (data['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data['change'] as String,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.bold,
                  color: data['color'] as Color,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildFooter(BuildContext context, double screenWidth, bool isTablet) {
    final buttonPadding = isTablet ? 16.0 : 12.0;
    final fontSize = isTablet ? 16.0 : 14.0;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: isTablet ? 20 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: isTablet
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildActionButton('Get Started', Icons.play_arrow, Colors.blue, buttonPadding, fontSize)),
                const SizedBox(width: 16),
                Expanded(child: _buildActionButton('Learn More', Icons.info, Colors.grey, buttonPadding, fontSize)),
                const SizedBox(width: 16),
                Expanded(child: _buildActionButton('Contact Us', Icons.contact_mail, Colors.green, buttonPadding, fontSize)),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildActionButton('Get Started', Icons.play_arrow, Colors.blue, buttonPadding, fontSize)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildActionButton('Learn More', Icons.info, Colors.grey, buttonPadding, fontSize)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _buildActionButton('Contact Us', Icons.contact_mail, Colors.green, buttonPadding, fontSize),
                ),
              ],
            ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, double padding, double fontSize) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: fontSize + 2),
      label: FittedBox(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    );
  }
}