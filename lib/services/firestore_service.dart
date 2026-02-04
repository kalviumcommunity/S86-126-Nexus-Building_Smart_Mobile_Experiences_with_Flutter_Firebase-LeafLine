import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create: Add user data to Firestore
  Future<void> addUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).set(data);
      print('User data added successfully');
    } catch (e) {
      print('Error adding user data: $e');
      rethrow;
    }
  }

  /// Create: Add a plant care note
  Future<void> addPlantNote(String uid, Map<String, dynamic> noteData) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('plant_notes')
          .add(noteData);
      print('Plant note added successfully');
    } catch (e) {
      print('Error adding plant note: $e');
      rethrow;
    }
  }

  /// Read: Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Read: Get plant notes stream for real-time updates
  Stream<QuerySnapshot> getPlantNotesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('plant_notes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Read: Get all plants from the plants collection (for plant database)
  Stream<QuerySnapshot> getPlantsStream() {
    return _firestore.collection('plants').orderBy('commonName').snapshots();
  }

  /// Read: Get a specific plant document
  Future<Map<String, dynamic>?> getPlant(String plantId) async {
    try {
      final doc = await _firestore.collection('plants').doc(plantId).get();
      return doc.data();
    } catch (e) {
      print('Error getting plant data: $e');
      return null;
    }
  }

  /// Read: Get user's plant collection stream
  Stream<QuerySnapshot> getUserPlantsStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('user_plants')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Read: Get a specific user plant
  Future<Map<String, dynamic>?> getUserPlant(String uid, String plantId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('user_plants')
          .doc(plantId)
          .get();
      return doc.data();
    } catch (e) {
      print('Error getting user plant data: $e');
      return null;
    }
  }

  /// Read: Get care logs for a specific user plant
  Stream<QuerySnapshot> getCareLogsStream(String uid, String plantId) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('user_plants')
        .doc(plantId)
        .collection('care_logs')
        .orderBy('performedAt', descending: true)
        .snapshots();
  }

  /// Read: Get reminders stream for a user
  Stream<QuerySnapshot> getRemindersStream(String uid) {
    return _firestore
        .collection('reminders')
        .where('userId', isEqualTo: uid)
        .orderBy('nextDue')
        .snapshots();
  }

  /// Read: Get active reminders only
  Stream<QuerySnapshot> getActiveRemindersStream(String uid) {
    return _firestore
        .collection('reminders')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: true)
        .orderBy('nextDue')
        .snapshots();
  }

  /// Read: Get care schedules for a specific plant
  Stream<QuerySnapshot> getCareSchedulesStream(String plantId) {
    return _firestore
        .collection('plants')
        .doc(plantId)
        .collection('care_schedules')
        .orderBy('priority', descending: true)
        .snapshots();
  }

  /// Read: Get all plant notes (legacy collection) - one-time read
  Future<List<Map<String, dynamic>>> getAllPlantNotes(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('plant_notes')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching plant notes: $e');
      return [];
    }
  }

  /// Read: Query plants by category
  Stream<QuerySnapshot> getPlantsByCategory(String category) {
    return _firestore
        .collection('plants')
        .where('category', isEqualTo: category)
        .orderBy('commonName')
        .snapshots();
  }

  /// Read: Query plants by difficulty level
  Stream<QuerySnapshot> getPlantsByDifficulty(String difficulty) {
    return _firestore
        .collection('plants')
        .where('difficulty', isEqualTo: difficulty)
        .orderBy('commonName')
        .snapshots();
  }

  /// Create: Add sample plants to database (for demo purposes)
  Future<void> addSamplePlants() async {
    final samplePlants = [
      {
        'scientificName': 'Monstera deliciosa',
        'commonName': 'Swiss Cheese Plant',
        'category': 'indoor',
        'difficulty': 'beginner',
        'description':
            'Popular houseplant known for its split leaves and air-purifying qualities.',
        'care_requirements': {
          'watering': {'frequency': 'weekly', 'amount': 'moderate'},
          'sunlight': {'intensity': 'bright indirect', 'duration': '6-8 hours'},
          'temperature': {'min': 65, 'max': 85},
          'humidity': {'min': 60, 'max': 80},
          'soil': {'type': 'well-draining potting mix'},
          'fertilization': {
            'frequency': 'monthly',
            'type': 'balanced houseplant fertilizer',
          },
        },
        'commonProblems': ['yellow leaves', 'brown tips', 'slow growth'],
        'careTips': [
          'Allow top inch of soil to dry between waterings',
          'Rotate plant quarterly for even growth',
          'Support climbing stems with moss pole',
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'scientificName': 'Sansevieria trifasciata',
        'commonName': 'Snake Plant',
        'category': 'indoor',
        'difficulty': 'beginner',
        'description':
            'Hardy succulent known for its tall, upright leaves with yellow edges.',
        'care_requirements': {
          'watering': {'frequency': 'every 2-3 weeks', 'amount': 'low'},
          'sunlight': {
            'intensity': 'low to bright indirect',
            'duration': '4-6 hours',
          },
          'temperature': {'min': 60, 'max': 85},
          'humidity': {'min': 30, 'max': 50},
          'soil': {'type': 'cactus/succulent mix'},
          'fertilization': {
            'frequency': 'every 2 months',
            'type': 'diluted succulent fertilizer',
          },
        },
        'commonProblems': ['root rot', 'leaf spots'],
        'careTips': [
          'Err on the side of underwatering',
          'Good for beginners and low-light areas',
          'Purifies air and releases oxygen at night',
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'scientificName': 'Ficus lyrata',
        'commonName': 'Fiddle Leaf Fig',
        'category': 'indoor',
        'difficulty': 'intermediate',
        'description': 'Stunning plant with large, violin-shaped leaves.',
        'care_requirements': {
          'watering': {'frequency': 'weekly', 'amount': 'moderate'},
          'sunlight': {'intensity': 'bright indirect', 'duration': '6-8 hours'},
          'temperature': {'min': 65, 'max': 75},
          'humidity': {'min': 50, 'max': 70},
          'soil': {'type': 'well-draining potting soil'},
          'fertilization': {
            'frequency': 'monthly',
            'type': 'balanced fertilizer',
          },
        },
        'commonProblems': ['leaf drop', 'brown spots', 'leggy growth'],
        'careTips': [
          'Keep away from drafty areas',
          'Maintain consistent temperature',
          'Mist leaves regularly for humidity',
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final plant in samplePlants) {
      try {
        await _firestore.collection('plants').add(plant);
        print('Added sample plant: ${plant['commonName']}');
      } catch (e) {
        print('Error adding sample plant: $e');
      }
    }
  }

  /// Create: Add a user plant to collection
  Future<void> addUserPlant(String uid, Map<String, dynamic> plantData) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('user_plants')
          .add({
            ...plantData,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
      print('User plant added successfully');
    } catch (e) {
      print('Error adding user plant: $e');
      rethrow;
    }
  }

  /// Create: Add a care log entry
  Future<void> addCareLog(
    String uid,
    String plantId,
    Map<String, dynamic> logData,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('user_plants')
          .doc(plantId)
          .collection('care_logs')
          .add({...logData, 'performedAt': FieldValue.serverTimestamp()});
      print('Care log added successfully');
    } catch (e) {
      print('Error adding care log: $e');
      rethrow;
    }
  }

  /// Create: Add a reminder
  Future<void> addReminder(Map<String, dynamic> reminderData) async {
    try {
      await _firestore.collection('reminders').add({
        ...reminderData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Reminder added successfully');
    } catch (e) {
      print('Error adding reminder: $e');
      rethrow;
    }
  }

  /// Read: Get a single plant note
  Future<Map<String, dynamic>?> getPlantNote(String uid, String noteId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('plant_notes')
          .doc(noteId)
          .get();
      return doc.data();
    } catch (e) {
      print('Error getting plant note: $e');
      return null;
    }
  }

  /// Update: Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      print('User data updated successfully');
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  /// Update: Update a specific plant note
  Future<void> updatePlantNote(
    String uid,
    String noteId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('plant_notes')
          .doc(noteId)
          .update(data);
      print('Plant note updated successfully');
    } catch (e) {
      print('Error updating plant note: $e');
      rethrow;
    }
  }

  /// Delete: Remove a plant note
  Future<void> deletePlantNote(String uid, String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('plant_notes')
          .doc(noteId)
          .delete();
      print('Plant note deleted successfully');
    } catch (e) {
      print('Error deleting plant note: $e');
      rethrow;
    }
  }

  /// Delete: Remove user data and all associated notes
  Future<void> deleteUserData(String uid) async {
    try {
      // Delete all plant notes first
      final notesSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('plant_notes')
          .get();

      for (final doc in notesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user document
      await _firestore.collection('users').doc(uid).delete();
      print('User data and notes deleted successfully');
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }
}
