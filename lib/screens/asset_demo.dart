import 'package:flutter/material.dart';

class AssetDemo extends StatelessWidget {
  const AssetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Local Image
            Image.asset(
              'assets/images/logo.png',
              width: screenWidth * 0.5,
            ),

            const SizedBox(height: 20),

            const Text(
              'LeafLine Asset Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Background image container
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Smart Plant Care',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Built-in icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.eco, color: Colors.green, size: 36),
                SizedBox(width: 12),
                Icon(Icons.local_florist, color: Colors.teal, size: 36),
                SizedBox(width: 12),
                Icon(Icons.water_drop, color: Colors.blue, size: 36),
              ],
            ),

            const SizedBox(height: 30),

            // Custom icon
            Image.asset(
              'assets/icons/leaf.png',
              width: 48,
            ),
          ],
        ),
      ),
    );
  }
}
