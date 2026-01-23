import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/responsive_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool clicked = false;

  void toggleText() {
    setState(() {
      clicked = !clicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeafLine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              clicked ? 'Welcome to LeafLine' : 'Smart Mobile Experience',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.eco, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleText,
              child: const Text('Toggle Text'),
            ),
            const SizedBox(height: 30),

            // LOGIN BUTTON (Sprint-2 Entry Point)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Get Started'),
            ),

            const SizedBox(height: 15),

            // OPTIONAL: Access responsive layout after login later
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResponsiveHome(),
                  ),
                );
              },
              child: const Text('View Responsive Layout'),
            ),
          ],
        ),
      ),
    );
  }
}
