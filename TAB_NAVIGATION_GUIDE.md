# Tab-Based Navigation Guide 📱

## Overview
Tab-based navigation is a core component of modern mobile apps. Apps like Instagram, YouTube, Twitter, and Spotify use bottom navigation to allow users to quickly switch between primary sections. Flutter provides multiple approaches to implement tab navigation with different benefits.

## ✨ Key Features

### Navigation Approaches
1. **Basic BottomNavigationBar** - Simple tab switching with state management
2. **PageView Navigation** - Smooth transitions with swipe gestures
3. **IndexedStack Navigation** - Full state preservation across tabs
4. **Material 3 NavigationBar** - Modern Material Design 3 styling

### Benefits
- ✅ **Fast, Intuitive Navigation**: Switch between major app sections instantly
- ✅ **Visible & Accessible**: Navigation UI always visible and accessible
- ✅ **State Preservation**: Keep screen state when switching tabs (with IndexedStack/PageView)
- ✅ **Smooth Animations**: Seamless transitions between screens
- ✅ **Best Practices**: Industry-standard navigation pattern
- ✅ **Customizable**: Full control over colors, icons, and behavior

---

## 🏗️ Implementation Approaches

### 1. Basic BottomNavigationBar

**When to Use:**
- Simple apps with 3-5 main sections
- No need for swipe gestures
- Screens don't have heavy state

**Implementation:**
```dart
class BasicTabNavigationScreen extends StatefulWidget {
  @override
  State<BasicTabNavigationScreen> createState() => _BasicTabNavigationScreenState();
}

class _BasicTabNavigationScreenState extends State<BasicTabNavigationScreen> {
  int _currentIndex = 0;

  // Define screens outside build() to avoid recreation
  static const List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

**Key Points:**
- Use `type: BottomNavigationBarType.fixed` for consistent sizing
- Define screens as `static const` outside build method
- Update `_currentIndex` in `onTap` callback
- Screens are rebuilt when switching tabs

---

### 2. PageView Navigation (Smooth & Fast)

**When to Use:**
- Want swipe gesture support
- Need smooth, animated transitions
- Better performance than basic approach
- Popular in social media and content apps

**Implementation:**
```dart
class PageViewNavigationScreen extends StatefulWidget {
  @override
  State<PageViewNavigationScreen> createState() => _PageViewNavigationScreenState();
}

class _PageViewNavigationScreenState extends State<PageViewNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          HomeTab(),
          ExploreTab(),
          FavoritesTab(),
          SettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
```

**Key Points:**
- `PageController` manages page navigation and animations
- `onPageChanged` updates selected tab when swiping
- `animateToPage()` creates smooth transitions
- Supports swipe gestures out of the box
- Better performance than rebuilding screens

---

### 3. IndexedStack Navigation (State Preservation)

**When to Use:**
- Need to preserve state across ALL tabs
- Forms, counters, timers, or heavy widgets
- Users frequently switch between tabs
- Don't want screens to reset when switching

**Implementation:**
```dart
class IndexedStackNavigationScreen extends StatefulWidget {
  @override
  State<IndexedStackNavigationScreen> createState() => _IndexedStackNavigationScreenState();
}

class _IndexedStackNavigationScreenState extends State<IndexedStackNavigationScreen> {
  int _currentIndex = 0;

  // All screens are built once and kept in memory
  static const List<Widget> _screens = [
    DashboardTab(),
    CounterTab(),
    FormTab(),
    TimerTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Counter'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Form'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        ],
      ),
    );
  }
}
```

**Key Points:**
- `IndexedStack` keeps all widgets in memory
- Only shows one child at a time based on `index`
- **No rebuilds when switching** - perfect for forms and timers
- Uses more memory (all screens remain in widget tree)
- State is fully preserved: counters keep counting, forms keep inputs, timers keep running

**Use Cases:**
- Form with multiple steps
- Shopping cart that persists
- Timer or stopwatch
- Text input that shouldn't reset
- Heavy data processing screens

---

### 4. Material 3 NavigationBar (Modern)

**When to Use:**
- Want latest Material Design 3 styling
- Better accessibility and touch targets
- Adaptive colors based on theme
- Modern, polished appearance

**Implementation:**
```dart
class Material3NavigationScreen extends StatefulWidget {
  @override
  State<Material3NavigationScreen> createState() => _Material3NavigationScreenState();
}

class _Material3NavigationScreenState extends State<Material3NavigationScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeTab(),
    LibraryTab(),
    CommunityTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar( // Note: NavigationBar, not BottomNavigationBar
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
```

**Key Points:**
- Use `NavigationBar` instead of `BottomNavigationBar`
- `NavigationDestination` instead of `BottomNavigationBarItem`
- Separate `icon` and `selectedIcon` for better visual feedback
- Automatically adapts to theme colors
- Better accessibility with larger touch targets
- Modern pill-shaped indicator animation

---

## 🎨 Customization Options

### Colors and Styling
```dart
BottomNavigationBar(
  selectedItemColor: Colors.blue,         // Color of selected item
  unselectedItemColor: Colors.grey,       // Color of unselected items
  selectedFontSize: 14,                   // Font size when selected
  unselectedFontSize: 12,                 // Font size when unselected
  showUnselectedLabels: true,             // Show labels for unselected items
  showSelectedLabels: true,               // Show label for selected item
  backgroundColor: Colors.white,           // Background color
  elevation: 8,                           // Shadow elevation
  type: BottomNavigationBarType.fixed,    // Fixed or shifting
)
```

### Navigation Bar Types
```dart
// Fixed: All items have equal width
type: BottomNavigationBarType.fixed,

// Shifting: Selected item is larger (requires 4+ items)
type: BottomNavigationBarType.shifting,
```

### Custom Icons
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.home_outlined),        // Unselected icon
  activeIcon: Icon(Icons.home),           // Selected icon (different style)
  label: 'Home',
  backgroundColor: Colors.blue,           // Background when shifting type
)
```

---

## 📊 Comparison Table

| Feature | Basic | PageView | IndexedStack | Material 3 |
|---------|-------|----------|--------------|------------|
| **Complexity** | Simple | Medium | Simple | Simple |
| **Swipe Gestures** | ❌ No | ✅ Yes | ❌ No | ❌ No |
| **State Preservation** | ❌ No | Partial | ✅ Full | ❌ No |
| **Memory Usage** | Low | Low | High | Low |
| **Smooth Animations** | ❌ No | ✅ Yes | ❌ No | ❌ No |
| **Modern Design** | ❌ No | ❌ No | ❌ No | ✅ Yes |
| **Best For** | Simple apps | Content apps | Forms/Timers | Modern UI |
| **Rebuilds on Switch** | ✅ Yes | ✅ Yes | ❌ No | ✅ Yes |

---

## 🎯 Best Practices

### 1. Optimal Tab Count
- **3-5 tabs recommended** - More than 5 becomes overwhelming
- **Minimum 3 tabs** - Less than 3, consider different navigation
- **Mobile-first** - Ensure tap targets are at least 48x48 pixels

### 2. Clear, Short Labels
```dart
✅ Good: 'Home', 'Search', 'Profile'
❌ Bad: 'Home Screen', 'Search Database', 'User Profile Settings'
```

### 3. Consistent Icon Choice
- Use Material Icons or custom icons consistently
- Outlined icons for unselected, filled for selected
- Make icons recognizable and intuitive
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.home_outlined),      // Outlined
  activeIcon: Icon(Icons.home),         // Filled
  label: 'Home',
)
```

### 4. Avoid Destructive Actions
```dart
❌ Bad: Logout, Delete Account, Clear Data
✅ Good: Home, Profile, Settings (put destructive actions inside Settings)
```

### 5. Keep Tabs Focused
- Each tab should represent a primary feature
- Don't mix unrelated functionality
- Users should know what to expect when tapping

### 6. State Management Best Practices
```dart
// ✅ Define screens outside build()
static const List<Widget> _screens = [
  HomeScreen(),
  SearchScreen(),
];

// ❌ Don't create screens inside build()
Widget build(BuildContext context) {
  final screens = [HomeScreen(), SearchScreen()]; // Bad!
  return Scaffold(...);
}
```

---

## 🐛 Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| **Tabs reset when switching** | Screens rebuilt on each switch | Use `IndexedStack` or `PageView` |
| **Navigation feels laggy** | Heavy rebuilds in build() | Use `const` widgets, extract expensive builds |
| **Incorrect tab highlights** | Index not synced with PageView | Update `_currentIndex` in `onPageChanged` |
| **Icons not visible** | No theme or wrong colors | Set `selectedItemColor` and `unselectedItemColor` |
| **Swipe not working** | Using basic BottomNavigationBar | Switch to `PageView` approach |
| **State lost on switch** | Screens rebuilt | Use `IndexedStack` for full state preservation |
| **PageController errors** | Not disposed properly | Call `_pageController.dispose()` in dispose() |
| **Too many tabs (6+)** | Overcrowded navigation | Reduce to 3-5, move extras to hamburger menu |

---

## 🧪 Testing Guide

### Test Scenario 1: Basic Navigation
1. Run the Basic Tab Navigation demo
2. Tap each tab and verify it switches screens
3. Verify selected tab is highlighted
4. Check that labels and icons display correctly

### Test Scenario 2: Swipe Gestures (PageView)
1. Run the PageView Navigation demo
2. Swipe left and right to navigate
3. Verify bottom navigation updates accordingly
4. Tap navigation items and verify smooth animation
5. Check that swiping and tapping both work

### Test Scenario 3: State Preservation (IndexedStack)
1. Run the IndexedStack Navigation demo
2. Go to Counter tab, increment counter to 10
3. Switch to Form tab, type some text
4. Go to Timer tab, start the timer
5. Switch between all tabs multiple times
6. **Verify:** Counter stays at 10, form text preserved, timer keeps running

**Expected Results:**
- ✅ Counter value persists
- ✅ Form inputs remain
- ✅ Timer continues running in background
- ✅ No screen resets occur

### Test Scenario 4: Material 3 Styling
1. Run the Material 3 Navigation demo
2. Observe modern pill-shaped indicator
3. Check icon transitions (outlined → filled)
4. Verify adaptive colors work with theme
5. Test touch targets are accessible

### Test Scenario 5: Performance
1. Run any demo with 4 tabs
2. Rapidly switch between tabs 20 times
3. Monitor for frame drops or lag
4. Check memory usage remains stable

---

## 📁 Project Files

### Demo Screens
- `lib/screens/tab_navigation_demo_screen.dart` - Main demo selector
- `lib/screens/basic_tab_navigation_screen.dart` - Basic implementation
- `lib/screens/pageview_navigation_screen.dart` - PageView with swipe gestures
- `lib/screens/indexed_stack_navigation_screen.dart` - Full state preservation
- `lib/screens/material3_navigation_screen.dart` - Material 3 NavigationBar

### How to Access
1. Launch the app
2. Scroll to **"📱 Tab Navigation"** section (blue/indigo gradient)
3. Tap **"View All Tab Demos"**
4. Select any demo to explore different approaches

---

## 🚀 Quick Start Code Template

**Copy-paste ready template for your app:**

```dart
import 'package:flutter/material.dart';

class MyTabNavigationApp extends StatefulWidget {
  @override
  State<MyTabNavigationApp> createState() => _MyTabNavigationAppState();
}

class _MyTabNavigationAppState extends State<MyTabNavigationApp> {
  int _currentIndex = 0;

  // Choose your approach:
  
  // Option 1: Basic (Simple, no state preservation)
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  // Option 2: PageView (Smooth, swipe gestures)
  // late PageController _pageController;
  // void initState() {
  //   super.initState();
  //   _pageController = PageController();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My App')),
      
      // Basic approach:
      body: _screens[_currentIndex],
      
      // PageView approach:
      // body: PageView(
      //   controller: _pageController,
      //   onPageChanged: (index) => setState(() => _currentIndex = index),
      //   children: _screens,
      // ),
      
      // IndexedStack approach:
      // body: IndexedStack(
      //   index: _currentIndex,
      //   children: _screens,
      // ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          // For PageView: _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Sample screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Screen', style: TextStyle(fontSize: 24)));
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search Screen', style: TextStyle(fontSize: 24)));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24)));
  }
}
```

---

## 📚 Additional Resources

- [Flutter BottomNavigationBar Docs](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html)
- [NavigationBar (Material 3)](https://api.flutter.dev/flutter/material/NavigationBar-class.html)
- [IndexedStack Widget](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html)
- [PageView Documentation](https://api.flutter.dev/flutter/widgets/PageView-class.html)
- [Material Design Navigation](https://m3.material.io/components/navigation-bar/overview)
- [Flutter Navigation Patterns](https://docs.flutter.dev/ui/navigation)

---

## Why Choose Each Approach?

### Choose **Basic** when:
- Building your first Flutter app
- Simple 3-4 section app
- No complex state to manage
- Quick prototyping

### Choose **PageView** when:
- Building social media or content browsing apps
- Swipe gestures are important for your UX
- Want smooth animations between tabs
- Need better performance than basic approach

### Choose **IndexedStack** when:
- Forms that should preserve user input
- Timers, counters, or stateful widgets
- Shopping carts or multi-step processes
- Users frequently switch tabs
- Performance is not a concern (memory usage higher)

### Choose **Material 3** when:
- Want modern, polished UI
- Following latest Material Design guidelines
- Need better accessibility
- Targeting newer Android/iOS versions

---

## Real-World Examples

### Instagram-Style Navigation (PageView)
```dart
// Home, Search, Reels, Shop, Profile
// Users swipe between content feeds
```

### Banking App Navigation (IndexedStack)
```dart
// Dashboard, Transfer, History, Profile
// Transfer form shouldn't reset when checking history
```

### E-commerce App (Basic)
```dart
// Shop, Cart, Orders, Account
// Simple navigation, cart state managed with Provider
```

### Streaming App (Material 3)
```dart
// Home, Library, Community
// Modern UI with adaptive theming
```

---

**Created:** February 10, 2026  
**Last Updated:** February 10, 2026  
**Flutter Version:** 3.x  
**Author:** LeafLine Team
