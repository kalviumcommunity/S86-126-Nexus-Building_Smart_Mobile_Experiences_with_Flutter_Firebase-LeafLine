import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
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
import 'screens/realtime_sync_demo_screen.dart';
import 'screens/query_filter_demo_screen.dart';
import 'screens/storage_upload_screen.dart';
import 'screens/cloud_functions_demo_screen.dart';
import 'screens/push_notifications_demo_screen.dart';
import 'screens/firestore_security_demo_screen.dart';
import 'screens/google_maps_demo_screen.dart';
import 'screens/crud_demo_screen.dart';
import 'screens/provider_crud_screen.dart';
import 'screens/forms_validation_demo.dart';
import 'screens/multi_step_form_demo.dart';
import 'screens/tab_navigation_demo_screen.dart';
import 'screens/basic_tab_navigation_screen.dart';
import 'screens/pageview_navigation_screen.dart';
import 'screens/indexed_stack_navigation_screen.dart';
import 'screens/material3_navigation_screen.dart';
import 'screens/theme_settings_screen.dart';
import 'screens/theme_demo_screen.dart';
import 'services/notification_service.dart';
import 'widgets/primary_button.dart';
import 'utils/page_transitions.dart';
import 'utils/app_themes.dart';
import 'providers/items_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Push Notifications (skip on web)
  if (!kIsWeb) {
    await NotificationService().initialize();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with MultiProvider for state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            
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
          '/cloudFunctions': (context) => const CloudFunctionsDemoScreen(),
          '/pushNotifications': (context) => const PushNotificationsDemoScreen(),
          '/firestoreSecurity': (context) => const FirestoreSecurityDemoScreen(),
          '/googleMaps': (context) => const GoogleMapsDemoScreen(),
          '/crudDemo': (context) => const CrudDemoScreen(),
          '/providerCrud': (context) => const ProviderCrudScreen(),
          '/formsValidation': (context) => const FormsValidationDemo(),
          '/multiStepForm': (context) => const MultiStepFormDemo(),
          '/tabNavigation': (context) => const TabNavigationDemoScreen(),
          '/basicTabNavigation': (context) => const BasicTabNavigationScreen(),
          '/pageViewNavigation': (context) => const PageViewNavigationScreen(),
          '/indexedStackNavigation': (context) => const IndexedStackNavigationScreen(),
          '/material3Navigation': (context) => const Material3NavigationScreen(),
          '/themeSettings': (context) => const ThemeSettingsScreen(),
          '/themeDemo': (context) => const ThemeDemoScreen(),
            },
          );
        },
      ),
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

  late AnimationController logoController;
  late AnimationController fadeController;
  late Animation<double> logoAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.elasticOut),
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    // Start animations
    logoController.forward();
    fadeController.forward();
  }

  @override
  void dispose() {
    logoController.dispose();
    fadeController.dispose();
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
          // Theme Settings Icon
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/themeSettings');
            },
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Theme Settings',
          ),
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
          opacity: fadeAnimation,
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
                            scale: logoAnimation,
                            child: AnimatedRotation(
                              duration: const Duration(milliseconds: 800),
                              turns: clicked ? 1.0 : 0.0,
                              child: const Icon(
                                Icons.eco,
                                size: 60,
                                color: Colors.green,
                              ),
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
                                Navigator.of(
                                  context,
                                ).pushWithFade(const LoginScreen());
                              },
                              child: const Text('Login'),
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushWithSlideFromRight(
                                  const WidgetTreeDemo(),
                                );
                              },
                              child: const Text('Widget Tree Demo'),
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushWithSlideFromLeft(
                                  const StatelessStatefulDemo(),
                                );
                              },
                              child: const Text('Stateless vs Stateful'),
                            ),
                          ),

                          PrimaryButton(
                            label: 'Scrollable Views',
                            onPressed: () {
                              Navigator.of(context).pushWithSlideFromBottom(
                                const ScrollableViews(),
                              );
                            },
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushWithScaleAndFade(const UserInputForm());
                              },
                              child: const Text('User Input Form'),
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushWithBouncySlide(
                                  const StateManagementDemo(),
                                );
                              },
                              child: const Text('State Management Demo'),
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushWithMixedTransition(const AssetDemo());
                              },
                              child: const Text('Assets Demo'),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Real-Time Sync Demo Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade600,
                                  Colors.indigo.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.bolt, color: Colors.yellow),
                                    SizedBox(width: 8),
                                    Text(
                                      '⚡ Real-Time Sync Demo',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Live Firestore Updates',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const RealtimeSyncDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.sync),
                                  label: const Text('Open Real-Time Demo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Firestore Security Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade600,
                                  Colors.pink.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.security,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '🔐 Firestore Security',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const FirestoreSecurityDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.shield),
                                  label: const Text('Open Security Demo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Firestore Query & Filter Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.teal.shade600,
                                  Colors.cyan.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.filter_list,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '🔍 Query & Filter Demo',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Firestore Queries, Sorting & Filtering',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const QueryFilterDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.search),
                                  label: const Text('Open Query Demo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Firebase Storage Upload Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepOrange.shade600,
                                  Colors.orange.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepOrange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '📤 Storage Upload Demo',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Firebase Storage with Image Picker',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const StorageUploadScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Open Upload Demo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.deepOrange,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Cloud Functions Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade600,
                                  Colors.lightGreen.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '☁️ Cloud Functions Demo',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Serverless Backend Functions',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CloudFunctionsDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.functions),
                                  label: const Text('Open Functions Demo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Push Notifications Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade600,
                                  Colors.purple.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.notifications_active,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '🔔 Push Notifications',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Firebase Cloud Messaging (FCM)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PushNotificationsDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text('Open Notifications'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Google Maps Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.teal.shade600,
                                  Colors.cyan.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.map, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      '🗺️ Google Maps',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Interactive Maps & User Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const GoogleMapsDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.location_on),
                                  label: const Text('Open Maps Demo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // CRUD Operations Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo.shade600,
                                  Colors.purple.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit_note, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      '📝 CRUD Operations',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Create, Read, Update, Delete',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const CrudDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.list_alt),
                                  label: const Text('Open CRUD Demo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.indigo,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Provider State Management CRUD Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade600,
                                  Colors.cyan.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.layers, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      '🚀 Provider State Management',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Scalable State with Provider + Forms',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const ProviderCrudScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.account_tree),
                                  label: const Text('Open Provider CRUD'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Forms Validation Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade600,
                                  Colors.deepOrange.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_box, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      '📋 Forms & Validation',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Complex Form Validation Examples',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const FormsValidationDemo(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit_note, size: 20),
                                      label: const Text('Validation Demo'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.orange,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const MultiStepFormDemo(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.stairs, size: 20),
                                      label: const Text('Multi-Step Form'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.deepOrange,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tab Navigation Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo.shade400,
                                  Colors.blue.shade400,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.view_carousel, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      '📱 Tab Navigation',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Bottom Navigation & Tab-Based UIs',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const TabNavigationDemoScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.navigation, size: 20),
                                  label: const Text('View All Tab Demos'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.indigo,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Animation Demos Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade400,
                                  Colors.pink.shade400,
                                ],
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
                                    Navigator.of(context).pushWithRotation(
                                      const AnimationDemoScreen(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.purple,
                                  ),
                                  child: const Text('Implicit Animations'),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushWithSizeTransition(
                                      const ExplicitAnimationDemo(),
                                    );
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
                          const SizedBox(height: 20),

                          // Theme & Styling Demo Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.teal.shade600,
                                  Colors.green.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.palette, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      '🎨 Theme & Dark Mode',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Custom Themes, Dark Mode & Material 3',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/themeDemo');
                                      },
                                      icon: const Icon(Icons.brightness_6, size: 20),
                                      label: const Text('Theme Demo'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.teal,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/themeSettings');
                                      },
                                      icon: const Icon(Icons.settings, size: 20),
                                      label: const Text('Settings'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
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
