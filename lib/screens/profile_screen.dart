import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? get _user => _authService.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.logOut();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Data - Single Document Read with FutureBuilder
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>?>(
              future: _firestoreService.getUserData(_user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error loading profile: ${snapshot.error}'),
                    ),
                  );
                }

                final userData = snapshot.data;
                if (userData == null) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No profile data found'),
                    ),
                  );
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              userData['name'] ?? 'No name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(userData['email'] ?? 'No email'),
                          ],
                        ),
                        if (userData['phone'] != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(userData['phone']),
                            ],
                          ),
                        ],
                        if (userData['address'] != null) ...[
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Address configured'),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          'Member since: ${_formatDate(userData['createdAt'])}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // User's Plant Collection - Real-time Stream
            const Text(
              'My Plants',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getUserPlantsStream(_user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error loading plants: ${snapshot.error}'),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.eco, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('No plants added yet'),
                        ],
                      ),
                    ),
                  );
                }

                final plants = snapshot.data!.docs;

                return Column(
                  children: plants.map((plant) {
                    final data = plant.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(
                          Icons.local_florist,
                          color: Colors.green,
                        ),
                        title: Text(data['nickname'] ?? 'Unnamed Plant'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location: ${data['location'] ?? 'Not specified'}',
                            ),
                            Text(
                              'Health: ${data['healthStatus'] ?? 'Unknown'}',
                            ),
                            Text(
                              'Last watered: ${_formatDate(data['lastWatered'])}',
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showPlantDetails(context, plant.id, data),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),

            // Active Reminders - Real-time Stream with Filter
            const Text(
              'Active Reminders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getActiveRemindersStream(_user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error loading reminders: ${snapshot.error}'),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('No active reminders'),
                        ],
                      ),
                    ),
                  );
                }

                final reminders = snapshot.data!.docs;

                return Column(
                  children: reminders.map((reminder) {
                    final data = reminder.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: _isOverdue(data['nextDue'])
                          ? Colors.red[50]
                          : null,
                      child: ListTile(
                        leading: Icon(
                          _getReminderIcon(data['reminderType']),
                          color: _isOverdue(data['nextDue'])
                              ? Colors.red
                              : Colors.orange,
                        ),
                        title: Text(data['title'] ?? 'Untitled Reminder'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['description'] ?? ''),
                            Text(
                              'Due: ${_formatDate(data['nextDue'])}',
                              style: TextStyle(
                                color: _isOverdue(data['nextDue'])
                                    ? Colors.red
                                    : Colors.black,
                                fontWeight: _isOverdue(data['nextDue'])
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not set';

    if (date is Timestamp) {
      final dateTime = date.toDate();
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }

    return 'Invalid date';
  }

  bool _isOverdue(dynamic nextDue) {
    if (nextDue == null || nextDue is! Timestamp) return false;
    return nextDue.toDate().isBefore(DateTime.now());
  }

  IconData _getReminderIcon(String? type) {
    switch (type) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.grass;
      case 'repotting':
        return Icons.refresh;
      case 'pruning':
        return Icons.content_cut;
      default:
        return Icons.notifications;
    }
  }

  void _showPlantDetails(
    BuildContext context,
    String plantId,
    Map<String, dynamic> data,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data['nickname'] ?? 'Plant Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Location: ${data['location'] ?? 'Not specified'}'),
              const SizedBox(height: 8),
              Text('Health Status: ${data['healthStatus'] ?? 'Unknown'}'),
              const SizedBox(height: 8),
              Text('Last Watered: ${_formatDate(data['lastWatered'])}'),
              const SizedBox(height: 8),
              Text('Last Fertilized: ${_formatDate(data['lastFertilized'])}'),
              const SizedBox(height: 8),
              if (data['notes'] != null && data['notes'].isNotEmpty) ...[
                const Text(
                  'Notes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['notes']),
              ],
              const SizedBox(height: 16),
              const Text(
                'Care History:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Show care logs for this plant
              StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getCareLogsStream(
                  _user!.uid,
                  plantId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No care history yet');
                  }

                  final logs = snapshot.data!.docs.take(3); // Show last 3 logs
                  return Column(
                    children: logs.map((log) {
                      final logData = log.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              _getActivityIcon(logData['activityType']),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${logData['activityType'] ?? 'Activity'} - ${_formatDate(logData['performedAt'])}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String? activityType) {
    switch (activityType) {
      case 'water':
        return Icons.water_drop;
      case 'fertilize':
        return Icons.grass;
      case 'repot':
        return Icons.refresh;
      case 'prune':
        return Icons.content_cut;
      default:
        return Icons.check_circle;
    }
  }
}
