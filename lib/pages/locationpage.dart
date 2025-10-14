import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soapy/util/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const LocationPage({super.key, required this.items});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(
    13.0827,
    80.2707,
  ); // Default Chennai location
  int _selectedCompanyIndex = -1; // Track selected company for info panel

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });

        // Load markers after getting current position
        _loadMapMarkers();

        // Center map on current position
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition, 12),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _loadMapMarkers() {
    setState(() {
      _markers.clear();

      // Add markers for all companies
      for (var i = 0; i < widget.items.length; i++) {
        final company = widget.items[i];
        _markers.add(
          Marker(
            markerId: MarkerId(company['company']),
            position: LatLng(company['lat'], company['lng']),
            infoWindow: InfoWindow(
              title: company['company'],
              snippet: company['subtitle'],
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            onTap: () {
              setState(() {
                _selectedCompanyIndex = i;
              });

              // Center the map on the selected marker with some padding for the bottom sheet
              _mapController?.animateCamera(
                CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                    southwest: LatLng(
                      company['lat'] - 0.01,
                      company['lng'] - 0.01,
                    ),
                    northeast: LatLng(
                      company['lat'] + 0.01,
                      company['lng'] + 0.01,
                    ),
                  ),
                  100, // padding
                ),
              );
            },
          ),
        );
      }

      // Add current location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition,
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current Position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  Future<void> openExternalMap(String query) async {
    final Uri googleMapUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open the map')));
      }
    }
  }

  Future<void> openDirections(double lat, double lng) async {
    final Uri directionsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    if (await canLaunchUrl(directionsUrl)) {
      await launchUrl(directionsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open directions')),
        );
      }
    }
  }

  // Zoom in function
  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  // Zoom out function
  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  Widget buildCompanyInfoPanel() {
    if (_selectedCompanyIndex < 0) return const SizedBox.shrink();

    final company = widget.items[_selectedCompanyIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle to drag the bottom sheet
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Company image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  company['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Company info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company['company'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company['subtitle'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Location info
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  company['location'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Time info
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey, size: 18),
              const SizedBox(width: 8),
              Text(company['timeRange'], style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 16),
              const Icon(Icons.directions_car, color: Colors.grey, size: 18),
              const SizedBox(width: 8),
              Text(company['distance'], style: const TextStyle(fontSize: 14)),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    openExternalMap(company['location']);
                  },
                  icon: const Icon(Icons.map, color: Colors.white),
                  label: const Text(
                    'View Map',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.loginButton,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    openDirections(company['lat'], company['lng']);
                  },
                  icon: const Icon(Icons.directions, color: Colors.white),
                  label: const Text(
                    'Directions',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.titleButton,
        title: const Text('Company Locations'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 12.0,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _loadMapMarkers();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // We'll add our own button
            zoomControlsEnabled: false, // Disable default zoom controls
            mapType: MapType.normal,
            onTap: (LatLng position) {
              // Clear selection when tapping on empty map area
              setState(() {
                _selectedCompanyIndex = -1;
              });
            },
            padding: EdgeInsets.only(
              bottom: _selectedCompanyIndex >= 0 ? 220 : 0,
            ),
          ),

          // Bottom company info panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: _selectedCompanyIndex >= 0
                  ? buildCompanyInfoPanel()
                  : const SizedBox.shrink(),
            ),
          ),

          // Zoom controls - positioned on the right side
          Positioned(
            top: 80, // Position below the list button
            right: 16,
            child: Column(
              children: [
                // Zoom in button
                FloatingActionButton.small(
                  heroTag: "zoomInButton",
                  onPressed: _zoomIn,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                const SizedBox(height: 8),
                // Zoom out button
                FloatingActionButton.small(
                  heroTag: "zoomOutButton",
                  onPressed: _zoomOut,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black),
                ),
              ],
            ),
          ),

          // Company list toggle button
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: "listButton",
              onPressed: () {
                _showCompanyList();
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.list, color: AppColor.loginButton),
            ),
          ),

          // My location button - positioned on the left side
          Positioned(
            bottom: _selectedCompanyIndex >= 0
                ? 240
                : 16, // Adjust based on info panel
            right: 16,
            child: FloatingActionButton.small(
              heroTag: "locationButton",
              onPressed: () {
                _getCurrentLocation();
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, color: AppColor.loginButton),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompanyList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Companies',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Companies list
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final company = widget.items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                company['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              company['company'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  company['subtitle'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                // Fixed Row with proper constraints
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        company['timeRange'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.directions_car,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      company['distance'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _selectedCompanyIndex = index;
                                });

                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(company['lat'], company['lng']),
                                    15,
                                  ),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedCompanyIndex = index;
                              });

                              _mapController?.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                  LatLng(company['lat'], company['lng']),
                                  15,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
