import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qris_pay_amount_screen.dart';

class QrisScanScreen extends StatefulWidget {
  const QrisScanScreen({super.key});

  @override
  State<QrisScanScreen> createState() => _QrisScanScreenState();
}

class _QrisScanScreenState extends State<QrisScanScreen> {
  MobileScannerController? _controller;
  bool _scanned = false;
  bool _cameraError = false;

  @override
  void initState() {
    super.initState();
    try {
      _controller = MobileScannerController();
    } catch (_) {
      _cameraError = true;
    }
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null) {
      _scanned = true;
      _navigateToPayment(barcode!.rawValue!);
    }
  }

  void _navigateToPayment(String qrValue) {
    final merchantName = qrValue.contains('TCPAY') ? 'TCPay Merchant' : 'Kantin Gedung A';
    final merchantId = 'QRIS-MERCHANT-001';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QrisPayAmountScreen(
          merchantName: merchantName,
          merchantId: merchantId,
        ),
      ),
    );
  }

  void _simulateScan() {
    if (_scanned) return;
    _scanned = true;
    _controller?.stop();
    _navigateToPayment('DEMO_SCAN');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan QRIS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_controller != null)
            IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.white),
              onPressed: () => _controller?.toggleTorch(),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (!_cameraError && _controller != null)
            MobileScanner(
              controller: _controller!,
              onDetect: _handleDetection,
            )
          else
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Kamera tidak tersedia',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          // Scanning overlay
          CustomPaint(
            size: Size.infinite,
            painter: _ScanOverlayPainter(),
          ),
          // Center frame label
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Arahkan kamera ke QR Code merchant',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          // Demo button at bottom
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _simulateScan,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Simulasi Scan (Demo)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE9800),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Atau gunakan tombol ini untuk demo tanpa kamera',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final frameSize = size.width * 0.65;
    final left = (size.width - frameSize) / 2;
    final top = (size.height - frameSize) / 2 - 40;
    final frameRect = Rect.fromLTWH(left, top, frameSize, frameSize);

    // Dark overlay outside frame
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(16))),
      ),
      paint,
    );

    // Corner accents
    final corner = Paint()
      ..color = const Color(0xFFFE9800)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const cLen = 24.0;
    final r = frameRect;

    // Top-left
    canvas.drawLine(Offset(r.left, r.top + cLen), Offset(r.left, r.top + 12), corner);
    canvas.drawLine(Offset(r.left, r.top), Offset(r.left + cLen, r.top), corner);
    // Top-right
    canvas.drawLine(Offset(r.right - cLen, r.top), Offset(r.right, r.top), corner);
    canvas.drawLine(Offset(r.right, r.top), Offset(r.right, r.top + cLen), corner);
    // Bottom-left
    canvas.drawLine(Offset(r.left, r.bottom - cLen), Offset(r.left, r.bottom), corner);
    canvas.drawLine(Offset(r.left, r.bottom), Offset(r.left + cLen, r.bottom), corner);
    // Bottom-right
    canvas.drawLine(Offset(r.right - cLen, r.bottom), Offset(r.right, r.bottom), corner);
    canvas.drawLine(Offset(r.right, r.bottom - cLen), Offset(r.right, r.bottom), corner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
