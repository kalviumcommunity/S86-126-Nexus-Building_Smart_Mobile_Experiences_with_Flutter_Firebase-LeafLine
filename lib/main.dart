import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/responsive_home.dart';
import 'screens/widget_tree_demo.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/scrollable_views.dart';
import 'screens/user_input_form.dart';

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
        '/userForm': (context) => const UserInputForm(),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                elevation: 8,
                child: Padding(
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
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedTheme == 'Dark'
                              ? Colors.grey[300]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 5,
                child: Padding(
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

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text('Login'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/widgetTree');
                        },
                        child: const Text('Widget Tree Demo'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/stateDemo');
                        },
                        child: const Text('Stateless vs Stateful'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/scrollable');
                        },
                        child: const Text('Scrollable Views'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/userForm');
                        },
                        child: const Text('User Input Form'),
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
