import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'login_screen.dart';
import 'plant_database_screen.dart';
import 'profile_screen.dart';
import 'demo_data_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _careInstructionsController =
      TextEditingController();

  @override
  void dispose() {
    _plantNameController.dispose();
    _careInstructionsController.dispose();
    super.dispose();
  }

  User? get _user => _authService.currentUser;

  Future<void> _handleLogout() async {
    await _authService.logOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _addPlantNote(BuildContext dialogContext) async {
    if (_plantNameController.text.trim().isEmpty ||
        _careInstructionsController.text.trim().isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    if (_user == null) return;

    try {
      await _firestoreService.addPlantNote(_user!.uid, {
        'plantName': _plantNameController.text.trim(),
        'careInstructions': _careInstructionsController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _plantNameController.clear();
      _careInstructionsController.clear();

      if (!mounted) return;
      Navigator.pop(dialogContext);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Plant note added')));
    } catch (e) {
      _showErrorDialog('Failed to add note');
    }
  }

  Future<void> _deletePlantNote(String noteId) async {
    if (_user == null) return;

    try {
      await _firestoreService.deletePlantNote(_user!.uid, noteId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Plant note deleted')));
    } catch (e) {
      _showErrorDialog('Failed to delete note');
    }
  }

  Future<void> _updatePlantNote(
    String noteId,
    String name,
    String instructions,
  ) async {
    if (_user == null) return;

    showDialog(
      context: context,
      builder: (_) => EditNoteDialog(
        plantName: name,
        careInstructions: instructions,
        onSave: (newName, newInstructions) async {
          try {
            await _firestoreService.updatePlantNote(_user!.uid, noteId, {
              'plantName': newName.trim(),
              'careInstructions': newInstructions.trim(),
            });

            if (!mounted) return;
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Plant note updated')));
          } catch (e) {
            _showErrorDialog('Failed to update note');
          }
        },
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Plant Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _plantNameController,
              decoration: const InputDecoration(
                labelText: 'Plant Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _careInstructionsController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Care Instructions',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _addPlantNote(dialogContext),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('LeafLine Dashboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.library_books),
            tooltip: 'Plant Database',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlantDatabaseScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.science),
            tooltip: 'Demo Data',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DemoDataScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getPlantNotesStream(_user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Icon(Icons.eco, size: 64, color: Colors.grey),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.local_florist, color: Colors.green),
                  title: Text(data['plantName'] ?? ''),
                  subtitle: Text(
                    data['careInstructions'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _updatePlantNote(
                          doc.id,
                          data['plantName'],
                          data['careInstructions'],
                        );
                      } else {
                        _deletePlantNote(doc.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EditNoteDialog extends StatefulWidget {
  final String plantName;
  final String careInstructions;
  final Function(String, String) onSave;

  const EditNoteDialog({
    super.key,
    required this.plantName,
    required this.careInstructions,
    required this.onSave,
  });

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plantName);
    _instructionsController = TextEditingController(
      text: widget.careInstructions,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _instructionsController,
            maxLines: 4,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_nameController.text, _instructionsController.text);
          },
          child: const Text('Save'),
        ),
      ],
=======
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          user != null
              ? 'Welcome, ${user.email}'
              : 'No user logged in',
          style: const TextStyle(fontSize: 18),
        ),
      ),

    );
  }
}
