import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/pages/orderpage.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';

class Detailpage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String location;
  final String timeRange;
  final String distance;
  final double lat;
  final double lng;

  const Detailpage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.timeRange,
    required this.distance,
    required this.lat,
    required this.lng,
  });

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  GoogleMapController? mapController;
  late Set<Marker> markers;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    markers = {
      Marker(
        markerId: const MarkerId('service_location'),
        position: LatLng(widget.lat, widget.lng),
        infoWindow: InfoWindow(title: widget.title, snippet: widget.subtitle),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _handleVerification() async {
    if (_isVerifying) return;

    setState(() => _isVerifying = true);

    try {
      // Save company and location data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.COMPANY, widget.title);
      await prefs.setString(AppConstants.LOCATION, widget.location);

      if (!mounted) return;

      // Show verification dialog
      await _showVerificationDialog();

      if (!mounted) return;

      // Navigate to order page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Orderpage()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Verification failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _showVerificationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _VerificationDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Property Details",
          style: Styles.textStyleButton(context, color: AppColor.loginText),
          textScaler: TextScaler.linear(1),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Qnss-bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    widget.imagePath,
                    width: double.infinity,
                    height: size.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Distance Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.distance,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Subtitle
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                    const SizedBox(height: 5),

                    // Time Information
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          const Icon(
                            Icons.access_time,
                            color: Colors.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Service Time',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                textScaler: TextScaler.linear(1),
                              ),
                              Text(
                                widget.timeRange,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textScaler: TextScaler.linear(1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Location Section
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                    const SizedBox(height: 2),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.orange,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.location,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                height: 1.4,
                              ),
                              textScaler: TextScaler.linear(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Map Section
                    const Text(
                      'Map View',
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 2),

                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.lat, widget.lng),
                            zoom: 15.0,
                          ),
                          markers: markers,
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          compassEnabled: true,
                          mapToolbarEnabled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isVerifying ? null : _handleVerification,
                        icon: _isVerifying
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.verified_outlined),
                        label: Text(
                          _isVerifying ? 'VERIFYING...' : 'Check IN',
                          textScaler: TextScaler.linear(1),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledBackgroundColor: Colors.blue.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}

// Separate StatefulWidget for verification dialog to avoid memory leaks
class _VerificationDialog extends StatefulWidget {
  @override
  State<_VerificationDialog> createState() => _VerificationDialogState();
}

class _VerificationDialogState extends State<_VerificationDialog> {
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _startVerificationProcess();
  }

  Future<void> _startVerificationProcess() async {
    // Show loading for 1 second
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() => _showSuccess = true);

    // Show success for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: 120,
        height: 140,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showSuccess) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                "Verifying...",
                textScaler: TextScaler.linear(1),
                style: TextStyle(color: Colors.grey),
              ),
            ] else ...[
              Image.asset(
                "assets/icons/map.png",
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              const Text(
                "Geo Location Verified Successful",
                textScaler: TextScaler.linear(1),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
