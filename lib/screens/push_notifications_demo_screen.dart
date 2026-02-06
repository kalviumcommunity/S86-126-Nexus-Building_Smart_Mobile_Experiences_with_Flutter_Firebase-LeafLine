import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';

/// Push Notifications Demo Screen
/// 
/// Demonstrates Firebase Cloud Messaging integration:
/// - Displays device FCM token
/// - Shows received notifications in real-time
/// - Handles foreground, background, and terminated states
/// - Topic subscription management

class PushNotificationsDemoScreen extends StatefulWidget {
  const PushNotificationsDemoScreen({super.key});

  @override
  State<PushNotificationsDemoScreen> createState() =>
      _PushNotificationsDemoScreenState();
}

class _PushNotificationsDemoScreenState
    extends State<PushNotificationsDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  final List<RemoteMessage> _messages = [];
  final TextEditingController _topicController = TextEditingController();

  String? _deviceToken;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initialize();
      
      setState(() {
        _deviceToken = _notificationService.deviceToken;
        _isInitialized = true;
      });

      // Listen to incoming messages
      _notificationService.onMessage.listen((RemoteMessage message) {
        setState(() {
          _messages.insert(0, message);
        });
      });

      _showSnackBar('Notifications initialized!', Colors.green);
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  void _copyTokenToClipboard() {
    if (_deviceToken != null) {
      Clipboard.setData(ClipboardData(text: _deviceToken!));
      _showSnackBar('Token copied to clipboard!', Colors.green);
    }
  }

  Future<void> _subscribeToTopic() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      _showSnackBar('Please enter a topic name', Colors.orange);
      return;
    }

    await _notificationService.subscribeToTopic(topic);
    _showSnackBar('Subscribed to topic: $topic', Colors.green);
    _topicController.clear();
  }

  Future<void> _unsubscribeFromTopic() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      _showSnackBar('Please enter a topic name', Colors.orange);
      return;
    }

    await _notificationService.unsubscribeFromTopic(topic);
    _showSnackBar('Unsubscribed from topic: $topic', Colors.blue);
    _topicController.clear();
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
        title: const Text('🔔 Push Notifications'),
        backgroundColor: Colors.deepPurple[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: !_isInitialized
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing notifications...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info Card
                  Card(
                    color: Colors.deepPurple[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: Colors.deepPurple[700],
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Firebase Cloud Messaging',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Receive push notifications in foreground, background, '
                            'and terminated states. Use the token below to send '
                            'test notifications from Firebase Console.',
                            style: TextStyle(
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Device Token Section
                  _buildSectionHeader('📱 Device Token', Icons.phone_android),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your FCM Device Token:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: SelectableText(
                              _deviceToken ?? 'No token available',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _copyTokenToClipboard,
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy Token'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Topic Subscription Section
                  _buildSectionHeader('📢 Topic Subscription', Icons.topic),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Subscribe to topics to receive targeted notifications:',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _topicController,
                            decoration: InputDecoration(
                              labelText: 'Topic Name',
                              hintText: 'e.g., news, updates, plants',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.label),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _subscribeToTopic,
                                  icon: const Icon(Icons.add_circle),
                                  label: const Text('Subscribe'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _unsubscribeFromTopic,
                                  icon: const Icon(Icons.remove_circle),
                                  label: const Text('Unsubscribe'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Received Messages Section
                  _buildSectionHeader(
                    '📬 Received Notifications (${_messages.length})',
                    Icons.inbox,
                  ),
                  const SizedBox(height: 12),
                  _messages.isEmpty
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No notifications yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Send a test notification from Firebase Console',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return _buildMessageCard(message);
                          },
                        ),
                  const SizedBox(height: 24),

                  // Instructions Card
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
                                'How to Test',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '1. Copy your device token above\n'
                            '2. Open Firebase Console → Messaging\n'
                            '3. Click "Send your first message"\n'
                            '4. Enter title and message text\n'
                            '5. Click "Send test message"\n'
                            '6. Paste your token and send\n'
                            '7. Notification will appear below!',
                            style: TextStyle(
                              color: Colors.grey[700],
                              height: 1.8,
                            ),
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
        Icon(icon, color: Colors.deepPurple[700], size: 24),
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

  Widget _buildMessageCard(RemoteMessage message) {
    final notification = message.notification;
    final timestamp = message.sentTime ?? DateTime.now();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification?.title ?? 'No Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (notification?.body != null) ...[
              const SizedBox(height: 12),
              Text(
                notification!.body!,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
            if (message.data.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Payload:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message.data.toString(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
