## LeafLine – Smart Mobile Experiences with Flutter & Firebase
# Project Overview

LeafLine is a Flutter application demonstrating responsive UI design, Firebase authentication, widget architecture, and multi-screen navigation using Flutter’s Navigator and named routes.

Sprint 2 Scope and Features
Responsive Flutter UI

Adaptive layouts for mobile, tablet, and landscape

MediaQuery and LayoutBuilder usage

Verified across multiple screen sizes

Firebase Authentication

Email and password login and signup

Session-based navigation

Secure user handling with Firebase Authentication

Widget Tree and Reactive UI

Clear widget hierarchy using MaterialApp and Scaffold

Reactive UI implemented with setState

Conditional rendering and animations

Interactive widget tree demo screen

Stateless vs Stateful Widgets

Side-by-side comparison

Counters, toggles, and theme switching

Demonstrates Flutter’s reactive programming model

Sprint 2: Multi-Screen Navigation
Navigation Approach

The application uses named routes defined in main.dart and Flutter’s Navigator to move between screens in a scalable and structured way.

Route Configuration
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const WelcomeScreen(),
    '/login': (context) => const LoginScreen(),
    '/responsive': (context) => const ResponsiveHome(),
    '/widgetTree': (context) => const WidgetTreeDemo(),
    '/stateDemo': (context) => const StatelessStatefulDemo(),
  },
);

Navigation Flow
WelcomeScreen
 ├─ /login
 ├─ /widgetTree
 ├─ /stateDemo
 └─ /responsive

Navigation Usage
Navigator.pushNamed(context, '/login');
Navigator.pop(context);

Reflection
How does Navigator manage the screen stack?

Navigator maintains a stack of routes. Each new screen is pushed onto the stack, and popping a route returns the user to the previous screen.

What are the benefits of named routes?

Centralized route management

Cleaner and more maintainable navigation logic

Easier scaling as the application grows

Reduced coupling between UI components and navigation logic

Project Structure
lib/
├── main.dart
├── firebase_options.dart
├── screens/
│   ├── login_screen.dart
│   ├── responsive_home.dart
│   ├── widget_tree_demo.dart
│   ├── stateless_stateful_demo.dart
│   └── signup_screen.dart
└── services/
    └── auth_service.dart

Running the Application
flutter pub get
flutter run

Screenshots

![alt text](image-1.png)

![alt text](image-2.png)

Navigation transition between screens

Sprint 2 Submission Details

Commit message:

feat: implemented multi-screen navigation using Navigator and routes


Pull request title:

[Sprint-2] Multi-Screen Navigation – TeamName

Reflection
Why is responsiveness important in mobile apps?

Responsiveness ensures that applications work consistently across different devices and orientations. A responsive UI improves usability, accessibility, and user experience without requiring separate layouts for each device type.

What challenges did you face while managing layout proportions?

The main challenge was maintaining consistent spacing and alignment when switching between vertical and horizontal layouts. Using Expanded and conditional layout rendering helped resolve proportion issues.

How can you improve the layout for different screen orientations?

The layout can be improved by adding orientation-specific spacing, adaptive font sizes, and additional breakpoints for large tablets and desktop screens.


Pull request includes:

Summary of the navigation setup

Screenshots from the README

Reflection on application navigation structure

Outcome

This project demonstrates responsive Flutter UI, Firebase authentication, widget tree structure, reactive UI behavior, and structured multi-screen navigation using Navigator and named routes.