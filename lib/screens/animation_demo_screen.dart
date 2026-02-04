import 'package:flutter/material.dart';

class AnimationDemoScreen extends StatefulWidget {
  const AnimationDemoScreen({super.key});

  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen> {
  // State variables for different animations
  bool _isExpanded = false;
  bool _isVisible = true;
  bool _isColorChanged = false;
  double _scale = 1.0;
  Alignment _alignment = Alignment.center;
  double _borderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations Demo'),
        backgroundColor: _isColorChanged ? Colors.teal : Colors.blue,
        elevation: _isExpanded ? 0 : 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AnimatedContainer Demo
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'AnimatedContainer Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutCubic,
                      width: _isExpanded ? 300 : 150,
                      height: _isExpanded ? 150 : 300,
                      decoration: BoxDecoration(
                        color: _isColorChanged 
                            ? Colors.teal.shade400 
                            : Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(_borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: (_isColorChanged ? Colors.teal : Colors.orange)
                                .withOpacity(0.3),
                            blurRadius: _isExpanded ? 20 : 10,
                            spreadRadius: _isExpanded ? 5 : 2,
                            offset: Offset(0, _isExpanded ? 10 : 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 500),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isExpanded ? 24 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                          child: const Text('Tap Below!'),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(_isExpanded ? 'Shrink' : 'Expand'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isColorChanged = !_isColorChanged;
                              _borderRadius = _borderRadius == 8.0 ? 50.0 : 8.0;
                            });
                          },
                          child: const Text('Change Color'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // AnimatedOpacity Demo
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'AnimatedOpacity Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 1000),
                      opacity: _isVisible ? 1.0 : 0.2,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade300, Colors.pink.shade300],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.star, size: 50, color: Colors.white),
                            const SizedBox(height: 10),
                            const Text(
                              'Fade In/Out Effect',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      child: Text(_isVisible ? 'Fade Out' : 'Fade In'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // AnimatedScale and AnimatedAlign Demo
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Scale & Position Animation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.elasticOut,
                        alignment: _alignment,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: _scale,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [Colors.yellow.shade400, Colors.red.shade400],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _alignment = Alignment.topLeft;
                            });
                          },
                          child: const Text('Top Left'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _alignment = Alignment.topRight;
                            });
                          },
                          child: const Text('Top Right'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _alignment = Alignment.center;
                            });
                          },
                          child: const Text('Center'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _scale = _scale == 1.0 ? 1.5 : 1.0;
                            });
                          },
                          child: Text(_scale == 1.0 ? 'Scale Up' : 'Scale Down'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Interactive Button with Hover Effect
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Interactive Button Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isExpanded 
                              ? [Colors.green.shade400, Colors.blue.shade400]
                              : [Colors.blue.shade400, Colors.purple.shade400],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: (_isExpanded ? Colors.green : Colors.blue)
                                .withOpacity(0.4),
                            blurRadius: _isExpanded ? 15 : 8,
                            spreadRadius: _isExpanded ? 3 : 1,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _isExpanded ? 'Awesome!' : 'Tap Me!',
                                key: ValueKey(_isExpanded),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: AnimatedRotation(
        duration: const Duration(milliseconds: 500),
        turns: _isColorChanged ? 0.5 : 0.0,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isColorChanged = !_isColorChanged;
              _isVisible = !_isVisible;
              _isExpanded = !_isExpanded;
            });
          },
          backgroundColor: _isColorChanged ? Colors.teal : Colors.orange,
          child: const Icon(Icons.animation),
        ),
      ),
    );
  }
}