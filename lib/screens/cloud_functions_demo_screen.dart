import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Cloud Functions Demo Screen
/// 
/// Demonstrates serverless backend functions:
/// - Callable functions (invoked from Flutter)
/// - Event-triggered functions (automatic Firestore triggers)

class CloudFunctionsDemoScreen extends StatefulWidget {
  const CloudFunctionsDemoScreen({super.key});

  @override
  State<CloudFunctionsDemoScreen> createState() =>
      _CloudFunctionsDemoScreenState();
}

class _CloudFunctionsDemoScreenState extends State<CloudFunctionsDemoScreen> {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _resultMessage = '';
  bool _isLoading = false;
  String _userName = 'Guest';

  // Form controllers
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _wateringController = TextEditingController();
  String _sunlightLevel = 'medium';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  void dispose() {
    _plantNameController.dispose();
    _wateringController.dispose();
    super.dispose();
  }

  void _checkAuthStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.email?.split('@')[0] ?? 'User';
      });
    }
  }

  /// Call sayHello callable function
  Future<void> _callSayHello() async {
    setState(() {
      _isLoading = true;
      _resultMessage = 'Calling Cloud Function...';
    });

    try {
      final HttpsCallable callable = _functions.httpsCallable('sayHello');
      final result = await callable.call(<String, dynamic>{
        'name': _userName,
      });

      setState(() {
        _resultMessage = '✅ Success!\n\n'
            'Message: ${result.data['message']}\n'
            'Timestamp: ${result.data['timestamp']}\n\n'
            'The function executed successfully in the cloud!';
        _isLoading = false;
      });

      _showSnackBar('Cloud Function executed!', Colors.green);
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error:\n$e';
        _isLoading = false;
      });
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    }
  }

  /// Call processPlantData callable function
  Future<void> _callProcessPlantData() async {
    if (_plantNameController.text.isEmpty || _wateringController.text.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.orange);
      return;
    }

    if (_auth.currentUser == null) {
      _showSnackBar('Please sign in to use this feature', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = 'Processing plant data...';
    });

    try {
      final HttpsCallable callable =
          _functions.httpsCallable('processPlantData');
      final result = await callable.call(<String, dynamic>{
        'plantName': _plantNameController.text,
        'wateringFrequency': int.parse(_wateringController.text),
        'sunlightLevel': _sunlightLevel,
      });

      final data = result.data['data'];
      final recommendations = (data['recommendations'] as List).join('\n• ');

      setState(() {
        _resultMessage = '✅ Plant Data Processed!\n\n'
            '🌿 Plant: ${data['plantName']}\n'
            '❤️ Health Score: ${data['healthScore']}/100\n'
            '💧 Watering: ${data['wateringFrequency']}x/week\n'
            '☀️ Sunlight: ${data['sunlightLevel']}\n\n'
            '📋 Recommendations:\n${recommendations.isNotEmpty ? "• $recommendations" : "None - looks perfect!"}\n\n'
            '${result.data['message']}';
        _isLoading = false;
      });

      _showSnackBar('Plant data processed!', Colors.green);
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error:\n$e';
        _isLoading = false;
      });
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    }
  }

  /// Trigger newUserCreated event function
  Future<void> _triggerNewUserEvent() async {
    setState(() {
      _isLoading = true;
      _resultMessage = 'Creating test user to trigger function...';
    });

    try {
      final testUserId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
      await _firestore.collection('users').doc(testUserId).set({
        'email': 'test@leafline.com',
        'name': 'Test User',
        'role': 'member',
      });

      await Future.delayed(const Duration(seconds: 2));

      final doc = await _firestore.collection('users').doc(testUserId).get();
      final data = doc.data()!;

      setState(() {
        _resultMessage = '✅ Event Function Triggered!\n\n'
            '👤 User ID: $testUserId\n'
            '📊 Status: ${data['accountStatus']}\n'
            '🎖️ Membership: ${data['membershipLevel']}\n'
            '🌱 Plants Added: ${data['plantsAdded']}\n'
            '🔔 Notifications: ${data['notificationsEnabled']}\n\n'
            'The Cloud Function automatically enriched the user profile!\n\n'
            '📝 Check Firebase Console → Functions → Logs for details.';
        _isLoading = false;
      });

      _showSnackBar('Check Firebase Console logs!', Colors.green);
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error:\n$e';
        _isLoading = false;
      });
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    }
  }

  /// Trigger plantAdded event function
  Future<void> _triggerPlantAddedEvent() async {
    if (_auth.currentUser == null) {
      _showSnackBar('Please sign in to add plants', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = 'Creating test plant...';
    });

    try {
      await _firestore.collection('plants').add({
        'name': 'Monstera Deliciosa',
        'userId': _auth.currentUser!.uid,
        'wateringFrequency': 2,
        'sunlightLevel': 'medium',
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _resultMessage = '✅ Plant Added Event Triggered!\n\n'
            '🌿 A plant was added to Firestore\n\n'
            'The Cloud Function automatically:\n'
            '• ✅ Updated your plant count\n'
            '• ✅ Added timestamp\n'
            '• ✅ Set status to "active"\n'
            '• ✅ Logged the event\n\n'
            '📝 Check Firebase Console → Functions → Logs';
        _isLoading = false;
      });

      _showSnackBar('Plant added! Check logs.', Colors.green);
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error:\n$e';
        _isLoading = false;
      });
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☁️ Cloud Functions Demo'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud_outlined,
                            color: Colors.green[700], size: 28),
                        const SizedBox(width: 12),
                        const Text(
                          'Serverless Backend',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Test Cloud Functions that run automatically without managing servers. '
                      'Callable functions respond to app requests, event-triggered functions '
                      'run automatically when Firestore data changes.',
                      style: TextStyle(color: Colors.grey[700], height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Callable Functions Section
            _buildSectionHeader('📞 Callable Functions', Icons.call_made),
            const SizedBox(height: 12),
            Text(
              'Invoke directly from Flutter and get immediate results',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Simple Hello Function
            _buildFunctionCard(
              title: '1. Say Hello Function',
              description: 'Simple greeting with your name',
              icon: Icons.waving_hand,
              color: Colors.blue,
              onPressed: _isLoading ? null : _callSayHello,
            ),
            const SizedBox(height: 16),

            // Advanced Plant Processing Function
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_florist,
                              color: Colors.purple),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2. Process Plant Data',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Advanced with auth & validation',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _plantNameController,
                      decoration: InputDecoration(
                        labelText: 'Plant Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.eco),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _wateringController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Watering (times/week)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.water_drop),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _sunlightLevel,
                      decoration: InputDecoration(
                        labelText: 'Sunlight Level',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.wb_sunny),
                      ),
                      items: ['low', 'medium', 'high']
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _sunlightLevel = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _callProcessPlantData,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('Process Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Event-Triggered Functions Section
            _buildSectionHeader('⚡ Event-Triggered Functions', Icons.flash_on),
            const SizedBox(height: 12),
            Text(
              'Run automatically when Firestore data changes',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 16),

            // New User Event
            _buildFunctionCard(
              title: '3. New User Created',
              description: 'Triggers on user document creation',
              icon: Icons.person_add,
              color: Colors.orange,
              onPressed: _isLoading ? null : _triggerNewUserEvent,
            ),
            const SizedBox(height: 16),

            // Plant Added Event
            _buildFunctionCard(
              title: '4. Plant Added',
              description: 'Triggers on plant document creation',
              icon: Icons.add_circle,
              color: Colors.teal,
              onPressed: _isLoading ? null : _triggerPlantAddedEvent,
            ),
            const SizedBox(height: 24),

            // Result Display
            if (_resultMessage.isNotEmpty) ...[
              _buildSectionHeader('📊 Result', Icons.receipt_long),
              const SizedBox(height: 12),
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isLoading
                      ? const Column(
                          children: [
                            CircularProgressIndicator(color: Colors.green),
                            SizedBox(height: 16),
                            Text(
                              'Executing...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      : SelectableText(
                          _resultMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 13,
                            height: 1.8,
                          ),
                        ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Instructions
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue[700], size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'View Function Logs',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Open Firebase Console\n'
                      '2. Navigate to Functions → Logs\n'
                      '3. Trigger any function above\n'
                      '4. Watch execution logs in real-time\n'
                      '5. Take screenshots for documentation',
                      style: TextStyle(color: Colors.grey[700], height: 1.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[700], size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Execute Function'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
