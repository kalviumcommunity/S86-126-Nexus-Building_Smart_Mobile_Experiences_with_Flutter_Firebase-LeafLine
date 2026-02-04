import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class PlantDatabaseScreen extends StatefulWidget {
  const PlantDatabaseScreen({super.key});

  @override
  State<PlantDatabaseScreen> createState() => _PlantDatabaseScreenState();
}

class _PlantDatabaseScreenState extends State<PlantDatabaseScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedCategory = 'all';
  String _selectedDifficulty = 'all';

  final List<String> _categories = ['all', 'indoor', 'outdoor', 'succulent'];
  final List<String> _difficulties = [
    'all',
    'beginner',
    'intermediate',
    'advanced',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Database'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            itemBuilder: (_) => _categories.map((category) {
              return PopupMenuItem(
                value: category,
                child: Text(
                  category == 'all' ? 'All Categories' : category.toUpperCase(),
                ),
              );
            }).toList(),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          // Difficulty filter chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _difficulties.map((difficulty) {
                final isSelected = _selectedDifficulty == difficulty;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      difficulty == 'all' ? 'All Levels' : difficulty,
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDifficulty = difficulty;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: Colors.green[100],
                    checkmarkColor: Colors.green,
                  ),
                );
              }).toList(),
            ),
          ),

          // Plant list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredPlantsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.eco, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No plants found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final plants = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    final plant = plants[index];
                    final data = plant.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(
                          Icons.local_florist,
                          color: Colors.green,
                        ),
                        title: Text(
                          data['commonName'] ?? 'Unknown Plant',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['scientificName'] ?? ''),
                            Row(
                              children: [
                                _buildDifficultyChip(data['difficulty']),
                                const SizedBox(width: 8),
                                _buildCategoryChip(data['category']),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showPlantDetails(context, plant.id, data),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getFilteredPlantsStream() {
    if (_selectedCategory != 'all' && _selectedDifficulty != 'all') {
      // For combined filters, use client-side filtering
      return _firestoreService.getPlantsStream();
    } else if (_selectedCategory != 'all') {
      return _firestoreService.getPlantsByCategory(_selectedCategory);
    } else if (_selectedDifficulty != 'all') {
      return _firestoreService.getPlantsByDifficulty(_selectedDifficulty);
    } else {
      return _firestoreService.getPlantsStream();
    }
  }

  Widget _buildDifficultyChip(String? difficulty) {
    Color color;
    switch (difficulty) {
      case 'beginner':
        color = Colors.green;
        break;
      case 'intermediate':
        color = Colors.orange;
        break;
      case 'advanced':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        difficulty ?? 'unknown',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildCategoryChip(String? category) {
    return Chip(
      label: Text(category ?? 'unknown', style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.blue[100],
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showPlantDetails(
    BuildContext context,
    String plantId,
    Map<String, dynamic> data,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data['commonName'] ?? 'Plant Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scientific Name: ${data['scientificName'] ?? 'N/A'}'),
              const SizedBox(height: 8),
              Text('Category: ${data['category'] ?? 'N/A'}'),
              const SizedBox(height: 8),
              Text('Difficulty: ${data['difficulty'] ?? 'N/A'}'),
              const SizedBox(height: 8),
              Text(
                'Description: ${data['description'] ?? 'No description available'}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Care Requirements:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (data['care_requirements'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Watering: ${(data['care_requirements'] as Map)['watering']?['frequency'] ?? 'N/A'}',
                ),
                Text(
                  'Sunlight: ${(data['care_requirements'] as Map)['sunlight']?['intensity'] ?? 'N/A'}',
                ),
                Text(
                  'Temperature: ${(data['care_requirements'] as Map)['temperature']?['min'] ?? 'N/A'}° - ${(data['care_requirements'] as Map)['temperature']?['max'] ?? 'N/A'}°',
                ),
              ],
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
}
