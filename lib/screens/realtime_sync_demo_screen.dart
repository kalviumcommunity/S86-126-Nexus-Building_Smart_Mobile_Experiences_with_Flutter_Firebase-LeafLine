import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Real-Time Sync Demo Screen
/// Demonstrates Firestore's snapshot listeners and real-time data synchronization
///
/// Features:
/// - Collection listener for live updates
/// - Document listener for single record updates
/// - Multiple StreamBuilders showing different use cases
/// - Instant UI updates when data changes in Firebase Console
class RealtimeSyncDemoScreen extends StatefulWidget {
  const RealtimeSyncDemoScreen({super.key});

  @override
  State<RealtimeSyncDemoScreen> createState() => _RealtimeSyncDemoScreenState();
}

class _RealtimeSyncDemoScreenState extends State<RealtimeSyncDemoScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();

  User? get _user => _authService.currentUser;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Add a real-time message to Firestore
  Future<void> _addMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('realtime_messages').add({
        'text': _messageController.text.trim(),
        'userId': _user?.uid ?? 'anonymous',
        'userEmail': _user?.email ?? 'anonymous',
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
      });

      _messageController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message added! Watch it appear instantly!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  /// Delete a message
  Future<void> _deleteMessage(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('realtime_messages')
          .doc(docId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message deleted! UI updated instantly!'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  /// Like a message
  Future<void> _likeMessage(String docId, int currentLikes) async {
    try {
      await FirebaseFirestore.instance
          .collection('realtime_messages')
          .doc(docId)
          .update({'likes': currentLikes + 1});
    } catch (e) {
      // Silent fail
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Sync Demo'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            color: Colors.deepPurple.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.deepPurple.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Real-Time Sync Active',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Changes made in Firebase Console will appear here instantly!',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // Input Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _addMessage,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),

          // Real-Time Stats
          _buildRealtimeStats(),

          // Real-Time Messages List
          Expanded(child: _buildRealtimeMessagesList()),
        ],
      ),
    );
  }

  /// Build real-time statistics
  Widget _buildRealtimeStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('realtime_messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final totalMessages = snapshot.data!.docs.length;
        final totalLikes = snapshot.data!.docs.fold<int>(
          0,
          (sum, doc) => sum + ((doc.data() as Map)['likes'] ?? 0) as int,
        );

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.message,
                label: 'Messages',
                value: totalMessages.toString(),
                color: Colors.blue,
              ),
              _buildStatItem(
                icon: Icons.favorite,
                label: 'Total Likes',
                value: totalLikes.toString(),
                color: Colors.red,
              ),
              _buildStatItem(
                icon: Icons.update,
                label: 'Auto-Updates',
                value: 'ON',
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// Build real-time messages list with StreamBuilder
  Widget _buildRealtimeMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      // 🔥 Real-Time Collection Listener
      stream: FirebaseFirestore.instance
          .collection('realtime_messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Connecting to real-time stream...'),
              ],
            ),
          );
        }

        // Error State
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        // Empty State
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your first message above!\nOr try adding one in Firebase Console.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final messages = snapshot.data!.docs;

        // ✅ Data Available - Build UI
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final doc = messages[index];
            final data = doc.data() as Map<String, dynamic>;
            final isCurrentUser = data['userId'] == _user?.uid;

            return _buildMessageCard(doc.id, data, isCurrentUser);
          },
        );
      },
    );
  }

  Widget _buildMessageCard(
    String docId,
    Map<String, dynamic> data,
    bool isCurrentUser,
  ) {
    final timestamp = data['timestamp'] as Timestamp?;
    final formattedTime = timestamp != null
        ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
        : 'Just now';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isCurrentUser
                      ? Colors.deepPurple
                      : Colors.grey,
                  radius: 16,
                  child: Text(
                    (data['userEmail'] as String?)
                            ?.substring(0, 1)
                            .toUpperCase() ??
                        'A',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['userEmail'] ?? 'Anonymous',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentUser)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _deleteMessage(docId),
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Message Text
            Text(data['text'] ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            // Like Button
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: (data['likes'] ?? 0) > 0 ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _likeMessage(docId, data['likes'] ?? 0),
                ),
                Text(
                  '${data['likes'] ?? 0}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('How Real-Time Sync Works'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This screen demonstrates Firestore snapshot listeners:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInfoPoint(
                '📡',
                'Collection Listener',
                'Monitors all documents in realtime_messages collection',
              ),
              _buildInfoPoint(
                '⚡',
                'Instant Updates',
                'UI refreshes automatically when data changes',
              ),
              _buildInfoPoint(
                '🔄',
                'StreamBuilder',
                'Rebuilds widgets when new snapshots arrive',
              ),
              _buildInfoPoint(
                '🎯',
                'Try It Out',
                'Add/edit/delete data in Firebase Console and watch this screen update!',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Code: .collection(\'realtime_messages\').snapshots()',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
