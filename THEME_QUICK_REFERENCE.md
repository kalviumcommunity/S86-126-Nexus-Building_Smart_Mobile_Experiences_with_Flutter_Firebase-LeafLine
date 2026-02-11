# 🎨 Quick Theme Reference Card

## 🚀 Quick Access

### Theme Settings
```dart
Navigator.pushNamed(context, '/themeSettings');
```

### Theme Demo
```dart
Navigator.pushNamed(context, '/themeDemo');
```

---

## 🔧 Provider Methods

```dart
// Get the provider
final themeProvider = Provider.of<ThemeProvider>(context);

// Or use Consumer
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    // Your widget here
  },
)
```

### Available Methods
```dart
themeProvider.setLightTheme()      // ☀️ Light mode
themeProvider.setDarkTheme()       // 🌙 Dark mode
themeProvider.setSystemTheme()     // 📱 System default
themeProvider.toggleTheme()        // 🔄 Toggle light/dark
```

### Properties
```dart
themeProvider.themeMode            // ThemeMode enum
themeProvider.themeModeString      // "Light", "Dark", "System"
themeProvider.themeIcon            // Icon for current mode
themeProvider.isLightMode          // bool
themeProvider.isExplicitDarkMode   // bool
themeProvider.isSystemMode         // bool
```

---

## 🎨 Using Theme Colors

### Get Current Theme
```dart
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;
final isDark = theme.brightness == Brightness.dark;
```

### Color Scheme
```dart
colorScheme.primary          // Primary brand color
colorScheme.secondary        // Secondary accent
colorScheme.tertiary         // Tertiary accent
colorScheme.error            // Error/warning color
colorScheme.surface          // Card/surface color
colorScheme.background       // Background color
```

### Text Styles
```dart
theme.textTheme.displayLarge    // 32px, bold
theme.textTheme.displayMedium   // 28px, bold
theme.textTheme.displaySmall    // 24px, semi-bold
theme.textTheme.headlineMedium  // 20px, semi-bold
theme.textTheme.bodyLarge       // 16px, regular
theme.textTheme.bodyMedium      // 14px, regular
theme.textTheme.labelLarge      // 16px, medium
```

---

## 📝 Common Patterns

### Themed Container
```dart
Container(
  color: theme.colorScheme.surface,
  child: Text(
    'Hello',
    style: theme.textTheme.bodyLarge,
  ),
)
```

### Conditional Styling
```dart
Container(
  color: isDark 
    ? Colors.grey[800] 
    : Colors.grey[100],
)
```

### Theme Toggle Button
```dart
IconButton(
  icon: Icon(themeProvider.themeIcon),
  onPressed: () => themeProvider.toggleTheme(),
)
```

### Theme Switch
```dart
Switch(
  value: themeProvider.isExplicitDarkMode,
  onChanged: (value) => themeProvider.toggleTheme(),
)
```

---

## 🎯 Material 3 Components

All components automatically adapt to theme:

- **ElevatedButton** - Filled with shadow
- **FilledButton** - Solid primary color
- **OutlinedButton** - Border with transparent fill
- **TextButton** - No border or fill
- **IconButton** - Icon with optional background
- **FloatingActionButton** - Primary-colored FAB
- **Card** - Surface with elevation
- **TextField** - Themed input fields
- **Switch** - Material 3 switch
- **Checkbox** - Themed checkbox
- **Radio** - Themed radio button
- **Slider** - Themed slider

---

## ⚡ Quick Examples

### 1. Add Theme Toggle to AppBar
```dart
AppBar(
  title: Text('My App'),
  actions: [
    Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return IconButton(
          icon: Icon(themeProvider.themeIcon),
          onPressed: () => themeProvider.toggleTheme(),
        );
      },
    ),
  ],
)
```

### 2. Theme-Aware Card
```dart
Card(
  elevation: theme.brightness == Brightness.dark ? 4 : 2,
  child: ListTile(
    leading: Icon(
      Icons.check,
      color: theme.colorScheme.primary,
    ),
    title: Text(
      'Item',
      style: theme.textTheme.bodyLarge,
    ),
  ),
)
```

### 3. Gradient with Theme Colors
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.secondary,
      ],
    ),
  ),
)
```

---

## 🎨 Custom Theme Colors

### Light Theme Palette
- **Primary**: Green (#4CAF50)
- **Secondary**: Teal (#009688)
- **Background**: Light Gray (#FAFAFA)
- **Surface**: White (#FFFFFF)

### Dark Theme Palette
- **Primary**: Teal (#26A69A)
- **Secondary**: Green Accent (#69F0AE)
- **Background**: Black (#000000)
- **Surface**: Dark Gray (#424242)

---

## 🔍 Debugging

### Check Current Theme
```dart
print('Current theme: ${themeProvider.themeModeString}');
print('Is dark: ${theme.brightness == Brightness.dark}');
```

### Verify Theme Persistence
1. Change theme
2. Restart app
3. Check if theme persists

### Theme Not Updating?
- Ensure `watch()` or `Consumer` is used
- Check provider is above widget in tree
- Verify `notifyListeners()` is called

---

## 📚 Files to Edit

### Add New Theme
- `lib/utils/app_themes.dart`

### Modify Theme Logic
- `lib/providers/theme_provider.dart`

### Update Settings UI
- `lib/screens/theme_settings_screen.dart`

### Add Demo Components
- `lib/screens/theme_demo_screen.dart`

---

## ✅ Testing Checklist

Quick test before deploying:

- [ ] Toggle theme in settings
- [ ] Verify theme persists on restart
- [ ] Check all screens in both themes
- [ ] Test system theme mode
- [ ] Verify icon colors are visible
- [ ] Check text contrast ratios
- [ ] Test on physical device (OLED)

---

## 🎯 Pro Tips

1. **Always use `Theme.of(context)`** - Never hardcode colors
2. **Test in both themes** - Some colors may not work in dark mode
3. **Use Material 3** - Modern, adaptive components
4. **OLED optimization** - Use true black (#000000) for dark theme
5. **Accessibility** - Ensure good contrast ratios
6. **Performance** - Theme changes are instant with Provider

---

**Need more help? Check [THEMING_GUIDE.md](THEMING_GUIDE.md) for detailed documentation.**
