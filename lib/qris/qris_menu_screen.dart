import 'package:flutter/material.dart';
import 'qris_scan_screen.dart';
import 'qris_mycode_screen.dart';

class QrisMenuScreen extends StatelessWidget {
  const QrisMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0040A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'QRIS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Layanan QRIS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Bayar merchant atau terima pembayaran dengan QR.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 28),
            _QrisMenuCard(
              icon: Icons.qr_code_scanner,
              title: 'Bayar dengan QRIS',
              subtitle: 'Scan QR code merchant untuk membayar',
              gradient: const LinearGradient(
                colors: [Color(0xFF0040A1), Color(0xFF0056D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              iconBgColor: Colors.white.withValues(alpha: 0.15),
              textColor: Colors.white,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrisScanScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _QrisMenuCard(
              icon: Icons.qr_code,
              title: 'Tampilkan Kode QRIS Saya',
              subtitle: 'Bagikan QR code untuk menerima pembayaran',
              gradient: null,
              iconBgColor: const Color(0xFFFE9800).withValues(alpha: 0.12),
              textColor: Colors.black87,
              borderColor: Colors.grey.shade200,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrisMyCodeScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrisMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient? gradient;
  final Color iconBgColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _QrisMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.iconBgColor,
    required this.textColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(20),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: gradient != null ? Colors.white : const Color(0xFFFE9800), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: gradient != null ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: gradient != null ? Colors.white70 : Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
