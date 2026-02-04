import 'package:flutter/material.dart';

class WidgetTreeDemo extends StatefulWidget {
  const WidgetTreeDemo({super.key});

  @override
  State<WidgetTreeDemo> createState() => _WidgetTreeDemoState();
}

class _WidgetTreeDemoState extends State<WidgetTreeDemo> {
  bool showDetails = false;
  int selectedNode = -1;
  String highlightedWidget = '';

  void toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  void selectNode(int index, String widgetName) {
    setState(() {
      selectedNode = index;
      highlightedWidget = widgetName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Tree Visualization'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: toggleDetails,
            icon: Icon(showDetails ? Icons.visibility_off : Icons.visibility),
          ),
        ],
      ),
      body: Column(
        children: [
          // Widget Tree Structure Display
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Widget Tree Structure:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildWidgetTreeNode('MaterialApp', 0, 0, true),
                    _buildWidgetTreeNode('Scaffold', 1, 1, true),
                    _buildWidgetTreeNode('AppBar', 2, 2, true),
                    _buildWidgetTreeNode('Column', 3, 1, true),
                    _buildWidgetTreeNode('Container', 4, 2, true),
                    _buildWidgetTreeNode('Card', 5, 3, showDetails),
                    _buildWidgetTreeNode('Row', 6, 4, showDetails),
                    _buildWidgetTreeNode('ElevatedButton', 7, 5, showDetails),
                    _buildWidgetTreeNode('Text', 8, 5, showDetails),
                    if (showDetails) ...[
                      _buildWidgetTreeNode('Icon', 9, 3, true),
                      _buildWidgetTreeNode('SizedBox', 10, 3, true),
                      _buildWidgetTreeNode('AnimatedContainer', 11, 2, true),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Interactive Demo Area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.deepPurple[50],
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Interactive Widget Demo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[800],
                          ),
                        ),
                        if (highlightedWidget.isNotEmpty)
                          Text(
                            'Currently highlighted: $highlightedWidget',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildInteractiveDemo(),
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

  Widget _buildWidgetTreeNode(String widgetName, int index, int level, bool visible) {
    if (!visible) return const SizedBox.shrink();

    bool isSelected = selectedNode == index;
    String prefix = '  ' * level + (level > 0 ? '└─ ' : '');
    
    return GestureDetector(
      onTap: () => selectNode(index, widgetName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isSelected ? Border.all(color: Colors.deepPurple) : null,
        ),
        child: Row(
          children: [
            Text(
              prefix,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              widgetName,
              style: TextStyle(
                fontFamily: 'monospace',
                color: isSelected ? Colors.deepPurple[800] : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return Column(
      children: [
        // Demo Card that matches the tree structure
        Expanded(
          child: Card(
            elevation: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => selectNode(8, 'Text'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: highlightedWidget == 'Text' 
                            ? Border.all(color: Colors.deepPurple, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'This is a Text Widget',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  GestureDetector(
                    onTap: () => selectNode(9, 'Icon'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: highlightedWidget == 'Icon' 
                            ? Border.all(color: Colors.deepPurple, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.widgets,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => selectNode(6, 'Row'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: highlightedWidget == 'Row' 
                            ? Border.all(color: Colors.deepPurple, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => selectNode(7, 'ElevatedButton'),
                            child: Container(
                              decoration: BoxDecoration(
                                border: highlightedWidget == 'ElevatedButton' 
                                    ? Border.all(color: Colors.deepPurple, width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ElevatedButton(
                                onPressed: toggleDetails,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(showDetails ? 'Hide Details' : 'Show Details'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => selectNode(7, 'ElevatedButton'),
                            child: Container(
                              decoration: BoxDecoration(
                                border: highlightedWidget == 'ElevatedButton' 
                                    ? Border.all(color: Colors.deepPurple, width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ElevatedButton(
                                onPressed: () => selectNode(-1, ''),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Reset Selection'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Widget Information Panel
                  if (highlightedWidget.isNotEmpty)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Widget: $highlightedWidget',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getWidgetDescription(highlightedWidget),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.deepPurple[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'Tap on any widget above to highlight it in the tree structure!',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getWidgetDescription(String widgetName) {
    switch (widgetName) {
      case 'MaterialApp':
        return 'Root widget that provides Material Design theme and navigation.';
      case 'Scaffold':
        return 'Provides the basic structure with AppBar, Body, and other components.';
      case 'AppBar':
        return 'Top application bar containing title and actions.';
      case 'Column':
        return 'Arranges children widgets vertically.';
      case 'Row':
        return 'Arranges children widgets horizontally.';
      case 'Container':
        return 'A box widget that can contain other widgets with styling.';
      case 'Card':
        return 'A Material Design card with elevation and rounded corners.';
      case 'Text':
        return 'Displays a string of text with optional styling.';
      case 'Icon':
        return 'Displays an icon from the Material Design icon library.';
      case 'ElevatedButton':
        return 'A Material Design raised button that responds to touches.';
      case 'SizedBox':
        return 'A box with a specified size, often used for spacing.';
      case 'AnimatedContainer':
        return 'A container that automatically animates changes to its properties.';
      default:
        return 'A Flutter widget that forms part of the widget tree.';
    }
  }
}