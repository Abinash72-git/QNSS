import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  
  String? scannedData;
  bool isScanning = true;
  bool flashOn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture barcodeCapture) {
    if (isScanning && barcodeCapture.barcodes.isNotEmpty) {
      final String? code = barcodeCapture.barcodes.first.rawValue;
      
      if (code != null && code.isNotEmpty) {
        setState(() {
          scannedData = code;
          isScanning = false;
        });
        
        // Stop scanning after successful scan
        controller.stop();
        
        // Show result dialog
        _showResultDialog(code);
      }
    }
  }

  void _showResultDialog(String data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(Icons.qr_code_scanner, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text(
              'QR Code Scanned',
              style: TextStyle(fontSize: 18),textScaler: TextScaler.linear(1),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scanned Data:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),textScaler: TextScaler.linear(1),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SelectableText(
                data,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),textScaler: TextScaler.linear(1),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Resume scanning
              setState(() {
                isScanning = true;
                scannedData = null;
              });
              controller.start();
            },
            child: const Text(
              'SCAN AGAIN',
              style: TextStyle(color: Colors.orange),textScaler: TextScaler.linear(1),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, data); // Return data to previous screen
              
              Fluttertoast.showToast(
                msg: "QR Code processed successfully",
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'CONFIRM',
              style: TextStyle(color: Colors.white),textScaler: TextScaler.linear(1),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    setState(() {
      flashOn = !flashOn;
    });
    controller.toggleTorch();
  }

  void _flipCamera() {
    controller.switchCamera();
  }

  Future<void> _pickImageAndScan() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Show loading indicator
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        // Analyze the image
        final BarcodeCapture? result = await controller.analyzeImage(image.path);

        // Close loading dialog
        if (mounted) {
          Navigator.pop(context);
        }

        if (result != null && result.barcodes.isNotEmpty) {
          final String? code = result.barcodes.first.rawValue;
          if (code != null && code.isNotEmpty) {
            setState(() {
              scannedData = code;
              isScanning = false;
            });
            _showResultDialog(code);
          } else {
            Fluttertoast.showToast(
              msg: "No QR code found in image",
              backgroundColor: Colors.orange,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "No QR code found in image",
            backgroundColor: Colors.orange,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error scanning image: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),textScaler: TextScaler.linear(1),
        ),
        actions: [
          IconButton(
            icon: Icon(
              flashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: _toggleFlash,
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: _flipCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          // QR Scanner View
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          
          // Custom overlay (drawn above camera preview)
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: size.width * 0.8,
              ),
            ),
          ),


          // Top instruction
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Align QR code within the frame to scan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),textScaler: TextScaler.linear(1),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Bottom information panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (scannedData != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Scanned: ${scannedData!.length > 30 ? scannedData!.substring(0, 30) + '...' : scannedData}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),textScaler: TextScaler.linear(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: flashOn ? Icons.flash_on : Icons.flash_off,
                        label: 'Flash',
                        onTap: _toggleFlash,
                      ),
                      _buildControlButton(
                        icon: Icons.flip_camera_ios,
                        label: 'Flip',
                        onTap: _flipCamera,
                      ),
                      _buildControlButton(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onTap: () async {
                          // Implement gallery image QR scanning
                          final BarcodeCapture? result = 
                              await controller.analyzeImage('path_to_image');
                          if (result != null && result.barcodes.isNotEmpty) {
                            _onDetect(result);
                          } else {
                            Fluttertoast.showToast(
                              msg: "No QR code found in image",
                              backgroundColor: Colors.orange,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),textScaler: TextScaler.linear(1),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom overlay shape for the scanner
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.green,
    this.borderWidth = 10.0,
    this.borderLength = 30.0,
    this.borderRadius = 10.0,
    this.cutOutSize = 300.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final cutOutWidth = cutOutSize;
    final cutOutHeight = cutOutSize;

    final backgroundPath = Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            rect.left + (width - cutOutWidth) / 2,
            rect.top + (height - cutOutHeight) / 2,
            cutOutWidth,
            cutOutHeight,
          ),
          Radius.circular(borderRadius),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      backgroundPath,
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final left = rect.left + (width - cutOutWidth) / 2;
    final top = rect.top + (height - cutOutHeight) / 2;
    final right = left + cutOutWidth;
    final bottom = top + cutOutHeight;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, top + borderLength)
        ..lineTo(left, top + borderRadius)
        ..arcToPoint(
          Offset(left + borderRadius, top),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(left + borderLength, top),
      borderPaint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(right - borderLength, top)
        ..lineTo(right - borderRadius, top)
        ..arcToPoint(
          Offset(right, top + borderRadius),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(right, top + borderLength),
      borderPaint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, bottom - borderLength)
        ..lineTo(left, bottom - borderRadius)
        ..arcToPoint(
          Offset(left + borderRadius, bottom),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(left + borderLength, bottom),
      borderPaint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(right - borderLength, bottom)
        ..lineTo(right - borderRadius, bottom)
        ..arcToPoint(
          Offset(right, bottom - borderRadius),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(right, bottom - borderLength),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderLength: borderLength,
      borderRadius: borderRadius,
      cutOutSize: cutOutSize,
    );
  }
}