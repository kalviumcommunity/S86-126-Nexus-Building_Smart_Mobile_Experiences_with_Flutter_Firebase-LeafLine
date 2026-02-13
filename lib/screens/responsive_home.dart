import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Responsive UI')),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: isTablet ? _tabletLayout() : _mobileLayout(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(onPressed: () {}, child: const Text('Continue')),
      ),
    );
  }

  Widget _mobileLayout() {
    return Column(
      children: [
        _box(Colors.green, 'Item 1'),
        const SizedBox(height: 12),
        _box(Colors.blue, 'Item 2'),
        const SizedBox(height: 12),
        _box(Colors.orange, 'Item 3'),
      ],
    );
  }

  Widget _tabletLayout() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _box(Colors.green, 'Item 1'),
        _box(Colors.blue, 'Item 2'),
        _box(Colors.orange, 'Item 3'),
        _box(Colors.purple, 'Item 4'),
      ],
    );
  }

  Widget _box(Color color, String text) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
