import 'package:flutter/material.dart';

/// IndexedStack-based navigation for state preservation
/// Screens are NOT rebuilt when switching tabs - perfect for heavy widgets
class IndexedStackNavigationScreen extends StatefulWidget {
  const IndexedStackNavigationScreen({super.key});

  @override
  State<IndexedStackNavigationScreen> createState() => _IndexedStackNavigationScreenState();
}

class _IndexedStackNavigationScreenState extends State<IndexedStackNavigationScreen> {
  int _currentIndex = 0;

  // All screens are built once and kept in memory
  static const List<Widget> _screens = [
    IndexedStackDashboard(),
    IndexedStackCounter(),
    IndexedStackForm(),
    IndexedStackTimer(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IndexedStack Navigation'),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Chip(
                label: const Text('State preserved', style: TextStyle(fontSize: 11)),
                backgroundColor: Colors.teal.shade100,
                avatar: const Icon(Icons.save, size: 16),
              ),
            ),
          ),
        ],
      ),
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
        ],
      ),
    );
  }
}

// Dashboard Tab
class IndexedStackDashboard extends StatelessWidget {
  const IndexedStackDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          color: Colors.teal.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.teal.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'IndexedStack Benefits',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '✓ State is preserved across tabs\n'
                  '✓ No widget rebuilds when switching\n'
                  '✓ Perfect for forms, timers, counters\n'
                  '✓ All screens in memory (uses more RAM)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Try It Out',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildInstructionCard(
          'Counter Tab',
          'Increment the counter, switch tabs, and return - value persists',
          Icons.add_circle,
          Colors.blue,
        ),
        _buildInstructionCard(
          'Form Tab',
          'Type in the form fields, switch tabs - your input remains',
          Icons.edit_note,
          Colors.orange,
        ),
        _buildInstructionCard(
          'Timer Tab',
          'Start the timer, switch tabs - it keeps running',
          Icons.timer,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildInstructionCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

// Counter Tab - Demonstrates state preservation
class IndexedStackCounter extends StatefulWidget {
  const IndexedStackCounter({super.key});

  @override
  State<IndexedStackCounter> createState() => _IndexedStackCounterState();
}

class _IndexedStackCounterState extends State<IndexedStackCounter> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, size: 80, color: Colors.blue.shade300),
          const SizedBox(height: 24),
          const Text(
            'Counter Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'State is preserved when switching tabs',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$_counter',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if (_counter > 0) _counter--;
                  });
                },
                backgroundColor: Colors.red.shade400,
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _counter = 0;
                  });
                },
                backgroundColor: Colors.grey.shade400,
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                backgroundColor: Colors.green.shade400,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tips_and_updates, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Switch to another tab and back - counter value persists!',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Form Tab - Demonstrates input preservation
class IndexedStackForm extends StatefulWidget {
  const IndexedStackForm({super.key});

  @override
  State<IndexedStackForm> createState() => _IndexedStackFormState();
}

class _IndexedStackFormState extends State<IndexedStackForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Icon(Icons.edit_note, size: 60, color: Colors.orange.shade300),
          const SizedBox(height: 16),
          const Text(
            'Form State Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Type something, switch tabs, and return - your input persists',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Message',
              prefixIcon: const Icon(Icons.message),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Form submitted!')),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Timer Tab - Demonstrates continuous state
class IndexedStackTimer extends StatefulWidget {
  const IndexedStackTimer({super.key});

  @override
  State<IndexedStackTimer> createState() => _IndexedStackTimerState();
}

class _IndexedStackTimerState extends State<IndexedStackTimer> {
  int _seconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRunning) {
        setState(() {
          _seconds++;
        });
        _startTimer();
      }
    });
  }

  String _formatTime() {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, size: 80, color: Colors.purple.shade300),
          const SizedBox(height: 24),
          const Text(
            'Timer Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Timer keeps running even when you switch tabs',
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatTime(),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isRunning = !_isRunning;
                    if (_isRunning) _startTimer();
                  });
                },
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isRunning ? 'Pause' : 'Start'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRunning ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _seconds = 0;
                    _isRunning = false;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tips_and_updates, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Switch tabs while timer is running - it continues!',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
