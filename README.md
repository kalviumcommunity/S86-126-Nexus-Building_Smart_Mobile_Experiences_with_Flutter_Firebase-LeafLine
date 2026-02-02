## LeafLine – Smart Mobile Experiences with Flutter
# Project Overview

This project demonstrates building smooth, efficient, and animated user interfaces in Flutter. The implementation includes scrollable views with ListView and GridView, along with comprehensive animations that bring the app to life with professional transitions and interactive elements.

## Latest Update: Flutter Animations & Transitions ✨

Added comprehensive animation system to enhance user experience:
- **Implicit animations** using AnimatedContainer, AnimatedOpacity, and AnimatedScale for smooth UI transitions
- **Explicit animations** with custom AnimationController for complex rotation, pulse, and wave effects  
- **Custom page transitions** using PageRouteBuilder with slide, fade, scale, and mixed transition effects
- **Enhanced scrollable views** with staggered entrance animations and interactive feedback
- **Animated navigation** with different transition effects for each screen

For detailed animation documentation, see [README_ANIMATIONS.md](README_ANIMATIONS.md)

---

## Scrollable Views with ListView and GridView

This task focuses on building smooth and efficient scrollable user interfaces in Flutter using ListView and GridView. The implementation demonstrates how Flutter handles large and dynamic data sets while maintaining performance and responsiveness across different screen sizes.

The screen combines a horizontal scrolling ListView and a grid-based layout using GridView, organized within a single scrollable page.

Scrollable Layout Design
ListView Implementation

A horizontal ListView.builder is used to display a scrollable list of cards.
The builder constructor ensures that only visible items are rendered, improving memory usage and performance.

ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: 5,
  itemBuilder: (context, index) {
    return Container(
      width: 140,
      margin: EdgeInsets.all(8),
      child: Center(child: Text('Card ${index + 1}')),
    );
  },
);

GridView Implementation

A GridView.builder is used to display items in a two-column grid layout.
The grid is embedded inside a SingleChildScrollView using shrinkWrap and disabled internal scrolling to avoid layout conflicts.

GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: 6,
  itemBuilder: (context, index) {
    return Container(
      child: Center(child: Text('Tile ${index + 1}')),
    );
  },
);

Screenshots

![alt text](image-1.png)

![alt text](image-2.png)

Reflection
How do ListView and GridView improve UI efficiency?

ListView and GridView efficiently manage scrolling content by rendering only the widgets that are visible on screen. This reduces memory usage and improves scrolling performance, especially when dealing with large or dynamic data sets.

Why are builder constructors recommended for large data sets?

Builder constructors such as ListView.builder and GridView.builder create widgets lazily. This means widgets are built only when needed, which significantly improves performance and prevents unnecessary widget creation.

What are common performance pitfalls to avoid with scrolling views?

Common pitfalls include nesting multiple scrollable widgets without controlling physics, rendering large lists without builders, and failing to constrain scrollable widgets inside fixed-height containers. Proper use of builders, constraints, and scroll physics helps avoid these issues.

Running the Application
flutter pub get
flutter run

Submission Details

Commit message:

feat: implemented scrollable layouts using ListView and GridView


Pull request title:

[Sprint-2] Scrollable Views with ListView & GridView – TeamName


Pull request includes:

Summary of scrollable layout implementation

Screenshots from the README

Reflection on ListView and GridView usage


 ## Task Setting Up Firebase Project and Connecting It to Flutter App
1.Create a Firebase project in the Firebase Console.
2.Register your Flutter app with Firebase (Android/iOS/Web).
3.Download google-services.json (Android) or GoogleService-Info.plist (iOS).
4.Add Firebase SDK dependencies in pubspec.yaml (firebase_core).
5.Configure Gradle files for Android integration.
6.Initialize Firebase in main.dart using Firebase.initializeApp().
7.Run the app and verify it appears in Firebase Console.


