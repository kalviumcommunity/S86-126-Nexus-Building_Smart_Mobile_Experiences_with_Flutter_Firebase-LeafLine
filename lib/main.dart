import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/responsive_home.dart';
import 'screens/widget_tree_demo.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/scrollable_views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/responsive': (context) => const ResponsiveHome(),
        '/widgetTree': (context) => const WidgetTreeDemo(),
        '/stateDemo': (context) => const StatelessStatefulDemo(),
        '/scrollable': (context) => const ScrollableViews(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // State variables for reactive UI demonstration
  bool clicked = false;
  int counter = 0;
  Color backgroundColor = Colors.blue;
  bool showExtraWidget = false;
  String selectedTheme = 'Light';

  void toggleText() {
    setState(() {
      clicked = !clicked;
    });
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void changeBackgroundColor() {
    setState(() {
      backgroundColor = backgroundColor == Colors.blue
          ? Colors.green
          : backgroundColor == Colors.green
          ? Colors.orange
          : Colors.blue;
    });
  }

  void toggleExtraWidget() {
    setState(() {
      showExtraWidget = !showExtraWidget;
    });
  }

  void changeTheme(String? value) {
    setState(() {
      selectedTheme = value ?? 'Light';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeafLine - Widget Tree Demo'),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: changeBackgroundColor,
            icon: const Icon(Icons.palette),
          ),
        ],
      ),
      body: Container(
        color: selectedTheme == 'Dark' ? Colors.grey[800] : Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Card Widget
              Card(
                elevation: 8,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        clicked
                            ? 'Welcome to LeafLine!'
                            : 'Smart Mobile Experience',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: selectedTheme == 'Dark'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Icon(Icons.eco, size: 60, color: Colors.green),
                      const SizedBox(height: 10),
                      Text(
                        'Demonstrating Flutter Widget Tree & Reactive UI',
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedTheme == 'Dark'
                              ? Colors.grey[300]
                              : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Interactive Elements Section
              Card(
                elevation: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Interactive Widget Tree Demo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: selectedTheme == 'Dark'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Counter Widget
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Counter:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '$counter',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: backgroundColor,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: incrementCounter,
                              icon: const Icon(Icons.add),
                              label: const Text('Increment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: backgroundColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Theme Selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Theme Selection:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('Light'),
                                    value: 'Light',
                                    groupValue: selectedTheme,
                                    onChanged: changeTheme,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('Dark'),
                                    value: 'Dark',
                                    groupValue: selectedTheme,
                                    onChanged: changeTheme,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Toggle Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: toggleText,
                              icon: const Icon(Icons.text_fields),
                              label: const Text('Toggle Text'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: toggleExtraWidget,
                              icon: Icon(
                                showExtraWidget
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              label: Text(
                                showExtraWidget ? 'Hide Widget' : 'Show Widget',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Conditionally Rendered Widget (Reactive UI Demo)
              if (showExtraWidget)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: 8,
                    color: backgroundColor.withOpacity(0.8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.star, size: 40, color: Colors.white),
                          const SizedBox(height: 10),
                          const Text(
                            'Dynamic Widget!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This widget appears and disappears reactively.\nCurrent counter: $counter',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Navigation Section
              Card(
                elevation: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Navigation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: selectedTheme == 'Dark'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // LOGIN BUTTON (Sprint-2 Entry Point)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Widget Tree Demo Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WidgetTreeDemo(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'View Widget Tree Demo',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Stateless vs Stateful Demo Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const StatelessStatefulDemo(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Stateless vs Stateful Demo',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // OPTIONAL: Access responsive layout
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
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
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/scrollable');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'View Scrollable Views',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
