import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore Security Demo Screen
///
/// Demonstrates:
/// 1. Authentication-protected Firestore operations
/// 2. How security rules block unauthorized access
/// 3. User-specific data isolation (users can only access their own data)
/// 4. Testing security rules in practice
class FirestoreSecurityDemoScreen extends StatefulWidget {
  const FirestoreSecurityDemoScreen({super.key});

  @override
  State<FirestoreSecurityDemoScreen> createState() =>
      _FirestoreSecurityDemoScreenState();
}

class _FirestoreSecurityDemoScreenState
    extends State<FirestoreSecurityDemoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  bool _isLoading = false;
  String _statusMessage = '';
  User? _currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _loadUserData();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  /// Sign in with email and password
  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _setStatus('❌ Please enter email and password', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _currentUser = credential.user;
        _statusMessage = '✅ Signed in as: ${_currentUser!.email}';
      });

      await _loadUserData();
    } on FirebaseAuthException catch (e) {
      _setStatus('❌ Sign-in failed: ${e.message}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Sign up new user
  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _setStatus('❌ Please enter email and password', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _currentUser = credential.user;
        _statusMessage = '✅ Account created: ${_currentUser!.email}';
      });

      // Initialize user document
      await _initializeUserData();
    } on FirebaseAuthException catch (e) {
      _setStatus('❌ Sign-up failed: ${e.message}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Sign out current user
  Future<void> _signOut() async {
    await _auth.signOut();
    setState(() {
      _currentUser = null;
      _userData = null;
      _statusMessage = '✅ Signed out successfully';
    });
  }

  /// Initialize user data (only works if authenticated)
  Future<void> _initializeUserData() async {
    if (_currentUser == null) {
      _setStatus('❌ No user signed in', isError: true);
      return;
    }

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'email': _currentUser!.email,
        'createdAt': FieldValue.serverTimestamp(),
        'testData': 'Initial data for ${_currentUser!.email}',
      });

      _setStatus('✅ User data initialized successfully', isError: false);
      await _loadUserData();
    } on FirebaseException catch (e) {
      _setStatus('❌ Firestore error: ${e.message}', isError: true);
    }
  }

  /// Load user data (demonstrates READ permission)
  Future<void> _loadUserData() async {
    if (_currentUser == null) {
      _setStatus('❌ No user signed in', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      setState(() {
        _userData = doc.data();
        _statusMessage = doc.exists
            ? '✅ Data loaded successfully'
            : '⚠️ No data found. Click "Write Data" to create.';
      });
    } on FirebaseException catch (e) {
      _setStatus(
        '❌ PERMISSION DENIED: ${e.message}\n\n'
        'This means security rules are working!\n'
        'You can only read your own data.',
        isError: true,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Write user data (demonstrates WRITE permission)
  Future<void> _writeUserData() async {
    if (_currentUser == null) {
      _setStatus('❌ No user signed in', isError: true);
      return;
    }

    final dataToWrite = _dataController.text.isEmpty
        ? 'Test data at ${DateTime.now()}'
        : _dataController.text;

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'email': _currentUser!.email,
        'testData': dataToWrite,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _setStatus('✅ Data written successfully', isError: false);
      await _loadUserData();
    } on FirebaseException catch (e) {
      _setStatus(
        '❌ PERMISSION DENIED: ${e.message}\n\n'
        'Security rules are protecting the database!',
        isError: true,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Try to access another user's data (should FAIL with security rules)
  Future<void> _testUnauthorizedAccess() async {
    if (_currentUser == null) {
      _setStatus('❌ No user signed in', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Try to access a different user's document
      const testUid = 'different-user-uid-12345';

      await _firestore.collection('users').doc(testUid).get();

      // If we reach here, security rules are NOT working properly
      _setStatus(
        '⚠️ WARNING: Security rules may not be deployed!\n'
        'We were able to read another user\'s data.\n\n'
        'Deploy firestore.rules to Firebase Console.',
        isError: true,
      );
    } on FirebaseException catch (e) {
      // This is the EXPECTED behavior with proper security rules
      _setStatus(
        '✅ SECURITY WORKING!\n\n'
        'Attempted to read another user\'s data.\n'
        'Result: ${e.code}\n\n'
        'This proves security rules are protecting user data!',
        isError: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _setStatus(String message, {required bool isError}) {
    setState(() => _statusMessage = message);
    if (isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Security Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          if (_currentUser != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
              tooltip: 'Sign Out',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.deepPurple.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Firestore Security Rules',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This screen demonstrates how Firebase Authentication '
                      'and Firestore Security Rules protect your database.\n\n'
                      '✅ Users can only read/write their own data\n'
                      '❌ Unauthorized access is blocked\n'
                      '🔐 Data is isolated by user ID',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Current User Status
            Card(
              color: _currentUser != null
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentUser != null ? '✅ Signed In' : '⚠️ Not Signed In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _currentUser != null
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                    if (_currentUser != null) ...[
                      const SizedBox(height: 8),
                      Text('Email: ${_currentUser!.email}'),
                      Text(
                        'UID: ${_currentUser!.uid}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Authentication Section
            if (_currentUser == null) ...[
              Text(
                'Step 1: Authenticate',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _signIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _signUp,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Sign Up'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Firestore Operations (only when signed in)
            if (_currentUser != null) ...[
              Text(
                'Step 2: Test Firestore Access',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 12),

              // User Data Display
              if (_userData != null)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Data:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Email: ${_userData!['email'] ?? 'N/A'}'),
                        Text('Test Data: ${_userData!['testData'] ?? 'N/A'}'),
                        if (_userData!['updatedAt'] != null)
                          Text(
                            'Updated: ${(_userData!['updatedAt'] as Timestamp).toDate()}',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // Data Input
              TextField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Test Data to Write',
                  border: OutlineInputBorder(),
                  hintText: 'Enter any text...',
                ),
              ),
              const SizedBox(height: 12),

              // Operation Buttons
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _loadUserData,
                icon: const Icon(Icons.download),
                label: const Text('Read My Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _writeUserData,
                icon: const Icon(Icons.upload),
                label: const Text('Write My Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Security Test
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Security Test',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Try to access another user\'s data.\n'
                        'This should FAIL if security rules are deployed.',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _testUnauthorizedAccess,
                        icon: const Icon(Icons.shield),
                        label: const Text('Test Unauthorized Access'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Status Message
            if (_statusMessage.isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                color:
                    _statusMessage.contains('❌') ||
                        _statusMessage.contains('⚠️')
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color:
                          _statusMessage.contains('❌') ||
                              _statusMessage.contains('⚠️')
                          ? Colors.red.shade900
                          : Colors.green.shade900,
                    ),
                  ),
                ),
              ),
            ],

            // Loading Indicator
            if (_isLoading) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
