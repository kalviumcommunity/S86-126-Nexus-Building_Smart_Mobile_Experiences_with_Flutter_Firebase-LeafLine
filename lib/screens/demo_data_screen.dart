import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class DemoDataScreen extends StatefulWidget {
  const DemoDataScreen({super.key});

  @override
  State<DemoDataScreen> createState() => _DemoDataScreenState();
}

class _DemoDataScreenState extends State<DemoDataScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  User? get _user => _authService.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Data Setup'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firestore Read Operations Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This screen helps you populate your Firestore database with sample data to test the read operations implemented in this lesson.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Sample Plants Section
            const Text(
              '1. Plant Database',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add sample plants to test collection reading and filtering.',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addSamplePlants,
              icon: const Icon(Icons.local_florist),
              label: const Text('Add Sample Plants'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // User Plants Section
            const Text(
              '2. My Plants Collection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add plants to your personal collection to test subcollection reading.',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addSampleUserPlants,
              icon: const Icon(Icons.add_circle),
              label: const Text('Add Sample User Plants'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // Care Logs Section
            const Text(
              '3. Care History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add care log entries to test nested subcollection reading.',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addSampleCareLogs,
              icon: const Icon(Icons.history),
              label: const Text('Add Sample Care Logs'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // Reminders Section
            const Text(
              '4. Reminders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add reminders to test filtered queries and real-time updates.',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addSampleReminders,
              icon: const Icon(Icons.notifications),
              label: const Text('Add Sample Reminders'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // Navigation Section
            const Text(
              '5. Test Read Operations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Navigate to different screens to see the read operations in action.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                    icon: const Icon(Icons.person),
                    label: const Text('View Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/plants'),
                    icon: const Icon(Icons.library_books),
                    label: const Text('Plant Database'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📖 How to Test Read Operations:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Use StreamBuilder for real-time data'),
                  Text('• Use FutureBuilder for single document reads'),
                  Text('• Test filtering in Plant Database screen'),
                  Text('• Check Profile screen for user data display'),
                  Text('• Modify data in Firebase Console to see live updates'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSamplePlants() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    try {
      await _firestoreService.addSamplePlants();
      _showSuccessSnackBar('Sample plants added successfully!');
    } catch (e) {
      _showErrorSnackBar('Error adding plants: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addSampleUserPlants() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    try {
      // Add a few sample user plants
      await _firestoreService.addUserPlant(_user!.uid, {
        'plantTypeId': 'monstera_deliciosa_001',
        'nickname': 'Monster',
        'location': 'Living Room',
        'healthStatus': 'healthy',
        'lastWatered': DateTime.now().subtract(const Duration(days: 3)),
        'notes': 'Growing well, new leaf emerging',
      });

      await _firestoreService.addUserPlant(_user!.uid, {
        'plantTypeId': 'snake_plant_001',
        'nickname': 'Snake',
        'location': 'Bedroom',
        'healthStatus': 'healthy',
        'lastWatered': DateTime.now().subtract(const Duration(days: 7)),
        'notes': 'Very low maintenance',
      });

      _showSuccessSnackBar('Sample user plants added successfully!');
    } catch (e) {
      _showErrorSnackBar('Error adding user plants: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addSampleCareLogs() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    try {
      // Get user's plants first
      final plantsSnapshot = await _firestoreService
          .getUserPlantsStream(_user!.uid)
          .first;
      if (plantsSnapshot.docs.isEmpty) {
        _showErrorSnackBar('Add user plants first!');
        return;
      }

      final plantId = plantsSnapshot.docs.first.id;

      // Add sample care logs
      await _firestoreService.addCareLog(_user!.uid, plantId, {
        'activityType': 'water',
        'description': 'Watered thoroughly, soil moist',
        'performedAt': DateTime.now().subtract(const Duration(days: 3)),
      });

      await _firestoreService.addCareLog(_user!.uid, plantId, {
        'activityType': 'fertilize',
        'description': 'Applied balanced fertilizer',
        'performedAt': DateTime.now().subtract(const Duration(days: 14)),
      });

      _showSuccessSnackBar('Sample care logs added successfully!');
    } catch (e) {
      _showErrorSnackBar('Error adding care logs: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addSampleReminders() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    try {
      await _firestoreService.addReminder({
        'userId': _user!.uid,
        'title': 'Water Monstera',
        'description': 'Time to water your Swiss Cheese Plant',
        'reminderType': 'watering',
        'frequency': 'weekly',
        'nextDue': DateTime.now().add(const Duration(days: 4)),
        'isActive': true,
      });

      await _firestoreService.addReminder({
        'userId': _user!.uid,
        'title': 'Fertilize Snake Plant',
        'description': 'Apply succulent fertilizer',
        'reminderType': 'fertilizing',
        'frequency': 'monthly',
        'nextDue': DateTime.now().add(const Duration(days: 11)),
        'isActive': true,
      });

      await _firestoreService.addReminder({
        'userId': _user!.uid,
        'title': 'Prune Fiddle Leaf Fig',
        'description': 'Remove any dead or yellow leaves',
        'reminderType': 'pruning',
        'frequency': 'monthly',
        'nextDue': DateTime.now().add(const Duration(days: 20)),
        'isActive': true,
      });

      _showSuccessSnackBar('Sample reminders added successfully!');
    } catch (e) {
      _showErrorSnackBar('Error adding reminders: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
