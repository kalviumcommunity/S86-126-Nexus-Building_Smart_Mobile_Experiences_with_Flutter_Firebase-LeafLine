import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

=======

import 'screens/login_screen.dart';
import 'screens/responsive_home.dart';
import 'screens/widget_tree_demo.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/scrollable_views.dart';
import 'screens/user_input_form.dart';
import 'screens/state_management_demo.dart';
import 'screens/asset_demo.dart';
import 'screens/animation_demo_screen.dart';
import 'screens/explicit_animation_demo.dart';
import 'widgets/primary_button.dart';
import 'utils/page_transitions.dart';

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

      home: LoginScreen(),
=======
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/responsive': (context) => const ResponsiveHome(),
        '/widgetTree': (context) => const WidgetTreeDemo(),
        '/stateDemo': (context) => const StatelessStatefulDemo(),
        '/scrollable': (context) => const ScrollableViews(),
        '/userForm': (context) => const UserInputForm(),
        '/stateManagement': (context) => const StateManagementDemo(),
        '/assets': (context) => const AssetDemo(),
        '/animations': (context) => const AnimationDemoScreen(),
        '/explicitAnimations': (context) => const ExplicitAnimationDemo(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> 
    with TickerProviderStateMixin {
  bool clicked = false;
  int counter = 0;
  Color backgroundColor = Colors.blue;
  bool showExtraWidget = false;
  String selectedTheme = 'Light';
  
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _logoController.forward();
    _fadeController.forward();
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

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
          AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: clicked ? 0.5 : 0.0,
            child: IconButton(
              onPressed: changeBackgroundColor,
              icon: const Icon(Icons.palette),
            ),
          ),
        ],
      ),
      body: Container(
        color: selectedTheme == 'Dark' ? Colors.grey[800] : Colors.grey[100],
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: clicked ? 12 : 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 400),
                            style: TextStyle(
                              fontSize: clicked ? 28 : 24,
                              fontWeight: FontWeight.bold,
                              color: selectedTheme == 'Dark'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Text(
                              clicked
                                  ? 'Welcome to LeafLine!'
                                  : 'Smart Mobile Experience',
                            ),
                          ),
                          const SizedBox(height: 10),
                          ScaleTransition(
                            scale: _logoAnimation,
                            child: AnimatedRotation(
                              duration: const Duration(milliseconds: 800),
                              turns: clicked ? 1.0 : 0.0,
                              child: const Icon(Icons.eco, size: 60, color: Colors.green),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 600),
                            opacity: clicked ? 1.0 : 0.7,
                            child: Text(
                              'Demonstrating Flutter Widget Tree & Reactive UI with Smooth Animations',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selectedTheme == 'Dark'
                                    ? Colors.grey[300]
                                    : Colors.grey[600],
                                fontSize: clicked ? 16 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: selectedTheme == 'Dark'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: const Text('Navigation'),
                          ),
                          const SizedBox(height: 15),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushWithFade(const LoginScreen());
                          },
                          child: const Text('Login'),
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushWithSlideFromRight(const WidgetTreeDemo());
                          },
                          child: const Text('Widget Tree Demo'),
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushWithSlideFromLeft(const StatelessStatefulDemo());
                          },
                          child: const Text('Stateless vs Stateful'),
                        ),
                      ),

                      PrimaryButton(
                        label: 'Scrollable Views',
                        onPressed: () {
                          Navigator.of(context).pushWithSlideFromBottom(const ScrollableViews());
                        },
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushWithScaleAndFade(const UserInputForm());
                          },
                          child: const Text('User Input Form'),
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushWithBouncySlide(const StateManagementDemo());
                          },
                          child: const Text('State Management Demo'),
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushWithMixedTransition(const AssetDemo());
                          },
                          child: const Text('Assets Demo'),
                        ),
                      ),

                      const SizedBox(height: 20),
                      
                      // Animation Demos Section
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade400, Colors.pink.shade400],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '✨ Animation Demos ✨',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushWithRotation(const AnimationDemoScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.purple,
                              ),
                              child: const Text('Implicit Animations'),
                            ),
                            
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushWithSizeTransition(const ExplicitAnimationDemo());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.purple,
                              ),
                              child: const Text('Explicit Animations'),
                            ),
                          ],
                        ),
                      ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: toggleText,
          backgroundColor: clicked ? Colors.green : backgroundColor,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              clicked ? Icons.check : Icons.touch_app,
              key: ValueKey(clicked),
            ),
          ),
        ),
      ),

    );
  }
}
