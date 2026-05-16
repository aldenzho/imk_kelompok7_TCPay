import 'package:flutter/material.dart';
import 'pintasan_cepat_screen.dart';

class SemuaPintasanScreen extends StatelessWidget {
  const SemuaPintasanScreen({super.key});

  static final List<Map<String, dynamic>> _semuaMenu = [
    {
      'label': 'Pulsa & Data',
      'icon': Icons.flash_on,
      'color': const Color(0xFF0040A1),
      'type': 'pulsaData',
      'items': [
        PintasanCepatItem(label: 'Pulsa 10.000', amount: 11000, description: 'Pulsa reguler semua operator'),
        PintasanCepatItem(label: 'Pulsa 25.000', amount: 26500, description: 'Pulsa reguler semua operator'),
        PintasanCepatItem(label: 'Pulsa 50.000', amount: 52000, description: 'Pulsa reguler semua operator'),
        PintasanCepatItem(label: 'Data 1GB/7 hari', amount: 15000, description: 'Paket data internet'),
        PintasanCepatItem(label: 'Data 5GB/30 hari', amount: 45000, description: 'Paket data internet'),
      ],
    },
    {
      'label': 'Kantin Perpus',
      'icon': Icons.coffee,
      'color': const Color(0xFF8A5100),
      'type': 'kantinPerpus',
      'items': [
        PintasanCepatItem(label: 'Paket Makan Siang', amount: 15000, description: 'Nasi + lauk + minuman'),
        PintasanCepatItem(label: 'Minuman & Snack', amount: 8000, description: 'Minuman dan camilan'),
        PintasanCepatItem(label: 'Kopi & Roti', amount: 12000, description: 'Kopi + roti bakar'),
        PintasanCepatItem(label: 'Paket Sarapan', amount: 10000, description: 'Bubur/nasi uduk + minuman'),
      ],
    },
    {
      'label': 'Sewa Kos',
      'icon': Icons.house,
      'color': const Color(0xFF2E7D32),
      'type': 'sewaKos',
      'items': [
        PintasanCepatItem(label: 'Kos Bulanan Tipe A', amount: 500000, description: 'Kamar standar tanpa AC'),
        PintasanCepatItem(label: 'Kos Bulanan Tipe B', amount: 750000, description: 'Kamar dengan AC'),
        PintasanCepatItem(label: 'Kos Bulanan Tipe C', amount: 1000000, description: 'Kamar AC + kamar mandi dalam'),
        PintasanCepatItem(label: 'Perpanjang 3 Bulan', amount: 2100000, description: 'Paket 3 bulan hemat 10%'),
      ],
    },
    {
      'label': 'Fotokopi',
      'icon': Icons.print,
      'color': const Color(0xFF6A1B9A),
      'type': 'fotokopi',
      'items': [
        PintasanCepatItem(label: '10 Lembar Hitam Putih', amount: 3000, description: 'Rp 300/lembar'),
        PintasanCepatItem(label: '50 Lembar Hitam Putih', amount: 12500, description: 'Rp 250/lembar'),
        PintasanCepatItem(label: '10 Lembar Berwarna', amount: 10000, description: 'Rp 1.000/lembar'),
        PintasanCepatItem(label: 'Jilid Spiral', amount: 5000, description: 'Penjilidan dokumen'),
      ],
    },
    {
      'label': 'Parkir Kampus',
      'icon': Icons.local_parking,
      'color': const Color(0xFF00796B),
      'type': 'parkirKampus',
      'items': [
        PintasanCepatItem(label: 'Motor Harian', amount: 2000, description: 'Parkir motor 1 hari'),
        PintasanCepatItem(label: 'Motor Bulanan', amount: 40000, description: 'Langganan parkir motor'),
        PintasanCepatItem(label: 'Mobil Harian', amount: 5000, description: 'Parkir mobil 1 hari'),
        PintasanCepatItem(label: 'Mobil Bulanan', amount: 150000, description: 'Langganan parkir mobil'),
      ],
    },
    {
      'label': 'Laundry',
      'icon': Icons.local_laundry_service,
      'color': const Color(0xFF1565C0),
      'type': 'laundry',
      'items': [
        PintasanCepatItem(label: 'Cuci Reguler 1 kg', amount: 6000, description: 'Selesai 2-3 hari'),
        PintasanCepatItem(label: 'Cuci Express 1 kg', amount: 9000, description: 'Selesai hari ini'),
        PintasanCepatItem(label: 'Cuci + Setrika 3 kg', amount: 21000, description: 'Paket lengkap'),
        PintasanCepatItem(label: 'Cuci Sepatu', amount: 25000, description: 'Termasuk pengeringan'),
      ],
    },
    {
      'label': 'Print Dokumen',
      'icon': Icons.description,
      'color': const Color(0xFFC62828),
      'type': 'printDokumen',
      'items': [
        PintasanCepatItem(label: 'Print HVS 10 hal', amount: 5000, description: 'Kertas A4 hitam putih'),
        PintasanCepatItem(label: 'Print HVS 50 hal', amount: 20000, description: 'Kertas A4 hitam putih'),
        PintasanCepatItem(label: 'Print Berwarna 10 hal', amount: 15000, description: 'Kertas A4 berwarna'),
        PintasanCepatItem(label: 'Scan Dokumen', amount: 5000, description: 'Scan ke PDF/JPG'),
      ],
    },
    {
      'label': 'Asuransi Kampus',
      'icon': Icons.health_and_safety,
      'color': const Color(0xFF558B2F),
      'type': 'asuransiKampus',
      'items': [
        PintasanCepatItem(label: 'Premi Bulanan', amount: 25000, description: 'Asuransi kesehatan dasar'),
        PintasanCepatItem(label: 'Premi Semesteran', amount: 130000, description: 'Hemat dibanding bulanan'),
        PintasanCepatItem(label: 'Premi Tahunan', amount: 250000, description: 'Perlindungan penuh 1 tahun'),
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F8),
      appBar: AppBar(
        title: const Text(
          'Semua Pintasan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0040A1),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0040A1)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: _semuaMenu.length,
        itemBuilder: (context, index) {
          final menu = _semuaMenu[index];
          final Color color = menu['color'] as Color;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PintasanCepatScreen(
                    title: menu['label'] as String,
                    icon: menu['icon'] as IconData,
                    color: color,
                    items: menu['items'] as List<PintasanCepatItem>,
                    paymentType: menu['type'] as String,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      menu['icon'] as IconData,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    menu['label'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
