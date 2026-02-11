import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Theme Demo Screen
///
/// Demonstrates the theming capabilities of the app including:
/// - How different widgets look in light/dark mode
/// - Real-time theme switching
/// - Material 3 design components
/// - Color scheme variations
class ThemeDemoScreen extends StatelessWidget {
  const ThemeDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeIcon),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/themeSettings');
            },
            tooltip: 'Theme Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('Theme Demonstration', style: theme.textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              'See how different components adapt to ${isDark ? "dark" : "light"} mode',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Color Scheme Section
            _SectionHeader(title: 'Color Scheme', theme: theme),
            const SizedBox(height: 12),
            _ColorPalette(),
            const SizedBox(height: 24),

            // Typography Section
            _SectionHeader(title: 'Typography', theme: theme),
            const SizedBox(height: 12),
            _TypographyDemo(theme: theme),
            const SizedBox(height: 24),

            // Buttons Section
            _SectionHeader(title: 'Buttons', theme: theme),
            const SizedBox(height: 12),
            _ButtonsDemo(),
            const SizedBox(height: 24),

            // Cards Section
            _SectionHeader(title: 'Cards & Containers', theme: theme),
            const SizedBox(height: 12),
            _CardsDemo(theme: theme),
            const SizedBox(height: 24),

            // Input Fields Section
            _SectionHeader(title: 'Input Fields', theme: theme),
            const SizedBox(height: 12),
            _InputFieldsDemo(),
            const SizedBox(height: 24),

            // Interactive Elements Section
            _SectionHeader(title: 'Interactive Elements', theme: theme),
            const SizedBox(height: 12),
            _InteractiveElementsDemo(),
            const SizedBox(height: 24),

            // Icons Section
            _SectionHeader(title: 'Icons', theme: theme),
            const SizedBox(height: 12),
            _IconsDemo(theme: theme),
            const SizedBox(height: 32),

            // Theme Toggle Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.palette,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Quick Theme Toggle',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try switching between themes to see the changes instantly',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => themeProvider.toggleTheme(),
                      icon: Icon(themeProvider.themeIcon),
                      label: Text(
                        'Switch to ${isDark ? "Light" : "Dark"} Mode',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/themeSettings');
        },
        icon: const Icon(Icons.settings),
        label: const Text('Settings'),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 24, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.headlineMedium),
      ],
    );
  }
}

class _ColorPalette extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ColorChip(color: colorScheme.primary, label: 'Primary'),
        _ColorChip(color: colorScheme.secondary, label: 'Secondary'),
        _ColorChip(color: colorScheme.tertiary, label: 'Tertiary'),
        _ColorChip(color: colorScheme.error, label: 'Error'),
        _ColorChip(color: colorScheme.surface, label: 'Surface'),
        _ColorChip(color: colorScheme.background, label: 'Background'),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _getContrastColor(color),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

class _TypographyDemo extends StatelessWidget {
  final ThemeData theme;

  const _TypographyDemo({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Display Large', style: theme.textTheme.displayLarge),
            Text('Display Medium', style: theme.textTheme.displayMedium),
            Text('Display Small', style: theme.textTheme.displaySmall),
            Text('Headline Medium', style: theme.textTheme.headlineMedium),
            Text('Body Large', style: theme.textTheme.bodyLarge),
            Text('Body Medium', style: theme.textTheme.bodyMedium),
            Text('Label Large', style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _ButtonsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text')),
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
          ],
        ),
      ),
    );
  }
}

class _CardsDemo extends StatelessWidget {
  final ThemeData theme;

  const _CardsDemo({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Standard Card'),
            subtitle: const Text('With elevation 2'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Elevated Card', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Higher elevation for emphasis',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InputFieldsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Standard Input',
                hintText: 'Enter text here',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'user@example.com',
                prefixIcon: Icon(Icons.email),
                suffixIcon: Icon(Icons.check),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractiveElementsDemo extends StatefulWidget {
  @override
  State<_InteractiveElementsDemo> createState() =>
      _InteractiveElementsDemoState();
}

class _InteractiveElementsDemoState extends State<_InteractiveElementsDemo> {
  bool switchValue = true;
  bool checkboxValue = true;
  double sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Switch'),
              value: switchValue,
              onChanged: (value) => setState(() => switchValue = value),
            ),
            CheckboxListTile(
              title: const Text('Checkbox'),
              value: checkboxValue,
              onChanged: (value) =>
                  setState(() => checkboxValue = value ?? false),
            ),
            Slider(
              value: sliderValue,
              onChanged: (value) => setState(() => sliderValue = value),
            ),
            RadioListTile<bool>(
              title: const Text('Radio Option'),
              value: true,
              groupValue: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}

class _IconsDemo extends StatelessWidget {
  final ThemeData theme;

  const _IconsDemo({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Icon(Icons.home, color: theme.colorScheme.primary),
            Icon(Icons.favorite, color: theme.colorScheme.secondary),
            Icon(Icons.settings, color: theme.colorScheme.tertiary),
            Icon(Icons.notifications, color: theme.colorScheme.primary),
            Icon(Icons.search, color: theme.colorScheme.secondary),
            Icon(Icons.person, color: theme.colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
}
