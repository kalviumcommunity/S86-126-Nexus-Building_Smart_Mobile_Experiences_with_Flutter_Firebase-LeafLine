import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

/// Google Maps Demo Screen
/// 
/// Demonstrates Google Maps integration with:
/// - Interactive map with pan and zoom
/// - User location tracking
/// - Custom markers
/// - Map controls and UI customization
/// - Multiple location examples

class GoogleMapsDemoScreen extends StatefulWidget {
  const GoogleMapsDemoScreen({super.key});

  @override
  State<GoogleMapsDemoScreen> createState() => _GoogleMapsDemoScreenState();
}

class _GoogleMapsDemoScreenState extends State<GoogleMapsDemoScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  MapType _currentMapType = MapType.normal;
  
  // Live location tracking
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLiveTrackingEnabled = false;
  BitmapDescriptor? _customMarkerIcon;

  // Default camera position (India - New Delhi)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 12,
  );

  // Sample locations for markers
  final List<Map<String, dynamic>> _sampleLocations = [
    {
      'name': 'India Gate',
      'location': const LatLng(28.6129, 77.2295),
      'info': 'Historic war memorial in New Delhi',
    },
    {
      'name': 'Qutub Minar',
      'location': const LatLng(28.5244, 77.1855),
      'info': 'UNESCO World Heritage Site',
    },
    {
      'name': 'Red Fort',
      'location': const LatLng(28.6562, 77.2410),
      'info': 'Historic fortification',
    },
    {
      'name': 'Lotus Temple',
      'location': const LatLng(28.5535, 77.2588),
      'info': 'Baháʼí House of Worship',
    },
    {
      'name': 'Humayun\'s Tomb',
      'location': const LatLng(28.5933, 77.2507),
      'info': 'Mughal architecture masterpiece',
    },
  ];

  @override
  void initState() {
    super.initState();
    _addSampleMarkers();
    _loadCustomMarkerIcon();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  /// Load custom marker icon (optional - will use default if not available)
  Future<void> _loadCustomMarkerIcon() async {
    try {
      // Try to load custom icon from assets
      // If the icon doesn't exist, this will fail silently and use default markers
      _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/icons/location_pin.png',
      );
      setState(() {});
    } catch (e) {
      // Custom icon not found - will use default colored markers
      debugPrint('Custom marker icon not found, using default markers');
    }
  }

  /// Add sample markers to the map
  void _addSampleMarkers() {
    for (var i = 0; i < _sampleLocations.length; i++) {
      final location = _sampleLocations[i];
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: location['location'] as LatLng,
          infoWindow: InfoWindow(
            title: location['name'] as String,
            snippet: location['info'] as String,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }
  }

  /// Check and request location permissions
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled. Please enable them.');
      return false;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  /// Get current user location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Add marker for current location
      _addCurrentLocationMarker(position);

      // Move camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );

      _showSnackBar('Location found: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  /// Move to a specific location
  void _moveToLocation(LatLng location, String name) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15,
        ),
      ),
    );
    _showSnackBar('Moving to $name');
  }

  /// Add or update current location marker
  void _addCurrentLocationMarker(Position position) {
    // Remove existing current location marker
    _markers.removeWhere((marker) => marker.markerId.value == 'current_location');
    
    // Add new marker with custom icon if available
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'Your Location',
          snippet: 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
        ),
        icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ),
    );
  }

  /// Toggle live location tracking
  void _toggleLiveTracking() async {
    if (_isLiveTrackingEnabled) {
      // Stop live tracking
      _positionStreamSubscription?.cancel();
      setState(() {
        _isLiveTrackingEnabled = false;
      });
      _showSnackBar('Live tracking stopped');
    } else {
      // Start live tracking
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) return;

      setState(() {
        _isLiveTrackingEnabled = true;
      });

      // Listen to position stream
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        setState(() {
          _currentPosition = position;
          _addCurrentLocationMarker(position);
        });

        // Optionally move camera to follow user
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      });

      _showSnackBar('Live tracking enabled - Following your location');
    }
  }

  /// Toggle map type
  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : _currentMapType == MapType.satellite
              ? MapType.terrain
              : MapType.normal;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🗺️ Google Maps Demo'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _toggleMapType,
            tooltip: 'Change Map Type',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
            tooltip: 'Info',
          ),
        ],
      ),
      body: Column(
        children: [
          // Info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.teal[50],
            child: Row(
              children: [
                Icon(Icons.map, color: Colors.teal[700], size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Interactive Google Maps with markers and user location',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  mapType: _currentMapType,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  onTap: (LatLng position) {
                    // Add custom marker on tap
                    _addCustomMarker(position);
                  },
                ),

                // Custom location button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Live tracking toggle button
                      FloatingActionButton(
                        heroTag: 'liveTrack',
                        onPressed: _toggleLiveTracking,
                        backgroundColor: _isLiveTrackingEnabled 
                            ? Colors.red 
                            : Colors.white,
                        child: Icon(
                          _isLiveTrackingEnabled 
                              ? Icons.stop 
                              : Icons.navigation,
                          color: _isLiveTrackingEnabled 
                              ? Colors.white 
                              : Colors.teal[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Get current location button
                      FloatingActionButton(
                        heroTag: 'getLocation',
                        onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                        backgroundColor: Colors.white,
                        child: _isLoadingLocation
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.my_location, color: Colors.teal[700]),
                      ),
                    ],
                  ),
                ),

                // Map type indicator
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      _currentMapType == MapType.normal
                          ? 'Normal'
                          : _currentMapType == MapType.satellite
                              ? 'Satellite'
                              : 'Terrain',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Location quick access buttons
          Container(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _sampleLocations.map((location) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => _moveToLocation(
                        location['location'] as LatLng,
                        location['name'] as String,
                      ),
                      icon: const Icon(Icons.place, size: 16),
                      label: Text(location['name'] as String),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Stats and controls
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.pin_drop,
                  'Markers',
                  _markers.length.toString(),
                ),
                _buildStatItem(
                  Icons.map,
                  'Map Type',
                  _currentMapType == MapType.normal
                      ? 'Normal'
                      : _currentMapType == MapType.satellite
                          ? 'Satellite'
                          : 'Terrain',
                ),
                _buildStatItem(
                  _isLiveTrackingEnabled ? Icons.navigation : Icons.location_on,
                  _isLiveTrackingEnabled ? 'Live Track' : 'GPS',
                  _isLiveTrackingEnabled 
                      ? 'Following' 
                      : _currentPosition != null 
                          ? 'Active' 
                          : 'Inactive',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.teal[700], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _addCustomMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('custom_${DateTime.now().millisecondsSinceEpoch}'),
          position: position,
          infoWindow: InfoWindow(
            title: 'Custom Marker',
            snippet: 'Lat: ${position.latitude.toStringAsFixed(4)}, '
                'Lng: ${position.longitude.toStringAsFixed(4)}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    });
    _showSnackBar('Marker added at ${position.latitude.toStringAsFixed(4)}, '
        '${position.longitude.toStringAsFixed(4)}');
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.map, color: Colors.teal),
            SizedBox(width: 8),
            Text('Google Maps Features'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🗺️ Interactive Map',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Pan and zoom with gestures'),
              Text('• Tap to add custom markers'),
              SizedBox(height: 12),
              Text(
                '📍 Markers',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Red: Sample locations'),
              Text('• Blue: Your current location'),
              Text('• Green: Custom markers'),
              SizedBox(height: 12),
              Text(
                '🎨 Map Types',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Normal: Default view'),
              Text('• Satellite: Aerial imagery'),
              Text('• Terrain: Topographic view'),
              SizedBox(height: 12),
              Text(
                '📱 Controls',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Navigation button: Live tracking (follows you)'),
              Text('• Location button: Find your position once'),
              Text('• Quick buttons: Jump to famous places'),
              Text('• Map type: Toggle between views'),
              SizedBox(height: 12),
              Text(
                '🔴 Live Tracking',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Tap navigation button to start'),
              Text('• Updates every 10 meters'),
              Text('• Camera follows your movement'),
              Text('• Tap again (stop) to disable'),
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
}
