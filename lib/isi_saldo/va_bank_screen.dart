import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/services/wallet_service.dart';

class VaBankScreen extends StatefulWidget {
  final int amount;
  const VaBankScreen({super.key, required this.amount});

  @override
  State<VaBankScreen> createState() => _VaBankScreenState();
}

class _VaBankScreenState extends State<VaBankScreen> {
  static const List<_VaBank> _banks = [
    _VaBank('BCA', 'BCA Virtual Account', 0xFF003087, '70012'),
    _VaBank('MDR', 'Mandiri Virtual Account', 0xFF0066AE, '88908'),
    _VaBank('BRI', 'BRI Virtual Account', 0xFF00529B, '26215'),
    _VaBank('BNI', 'BNI Virtual Account', 0xFF004B87, '8277'),
    _VaBank('CMB', 'CIMB Niaga Virtual Account', 0xFF7B0000, '9311'),
    _VaBank('PMT', 'Permata Virtual Account', 0xFF003A70, '8015'),
    _VaBank('BTN', 'BTN Virtual Account', 0xFF006B3F, '39314'),
    _VaBank('DAM', 'Danamon Virtual Account', 0xFFE20613, '125'),
  ];

  _VaBank? _selected;
  bool _showInstructions = false;
  bool _isLoading = false;
  String? _vaNumber;

  String _formatRp(int val) {
    final str = val.toString();
    final buf = StringBuffer('Rp ');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  Future<void> _generateVa(_VaBank bank) async {
    setState(() {
      _selected = bank;
      _isLoading = true;
      _showInstructions = false;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    final unique = (widget.amount % 1000).toString().padLeft(3, '0');
    setState(() {
      _isLoading = false;
      _showInstructions = true;
      _vaNumber = '${bank.prefix}8821$unique';
    });
  }

  Future<void> _simulateTopUp() async {
    try {
      await WalletService().topUpBalance(
        amount: widget.amount,
        method: 'VA ${_selected!.shortName}',
      );
      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Top up ${_formatRp(widget.amount)} berhasil! Saldo telah bertambah.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
      );
    }
  }

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
          'Virtual Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Nominal card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0040A1), Color(0xFF0056D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nominal Top Up', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(height: 4),
                  ],
                ),
                Text(
                  _formatRp(widget.amount),
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Pilih Bank',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 3.0,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: _banks.map((bank) {
              final isSelected = _selected == bank;
              return GestureDetector(
                onTap: () => _generateVa(bank),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0040A1) : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(bank.color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            bank.shortName,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(bank.color),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bank.shortName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? const Color(0xFF0040A1) : Colors.black87,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.check_circle, color: Color(0xFF0040A1), size: 18),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: Color(0xFF0040A1)),
              ),
            ),

          if (_showInstructions && _selected != null && _vaNumber != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0040A1).withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(_selected!.color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _selected!.shortName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(_selected!.color),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selected!.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Text('Nomor Virtual Account', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _vaNumber!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Color(0xFF0040A1),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Color(0xFF0040A1)),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _vaNumber!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Nomor VA disalin')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _infoRow('Total Transfer', _formatRp(widget.amount)),
                  const SizedBox(height: 8),
                  _infoRow('Berlaku sampai', _expiryTime()),
                  const SizedBox(height: 16),
                  const Text(
                    'Cara Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  ..._instructions(_selected!.shortName).map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0040A1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${_instructions(_selected!.shortName).indexOf(step) + 1}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(step, style: const TextStyle(fontSize: 13, height: 1.4)),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _simulateTopUp,
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: const Text(
                        'Simulasikan Pembayaran Berhasil',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      '(Tombol ini hanya untuk demo — di produksi saldo bertambah otomatis setelah bank konfirmasi)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _expiryTime() {
    final exp = DateTime.now().add(const Duration(hours: 24));
    return '${exp.day.toString().padLeft(2, '0')}/${exp.month.toString().padLeft(2, '0')}/${exp.year} '
        '${exp.hour.toString().padLeft(2, '0')}:${exp.minute.toString().padLeft(2, '0')} WIB';
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  List<String> _instructions(String bank) {
    switch (bank) {
      case 'BCA':
        return [
          'Buka aplikasi BCA Mobile atau akses KlikBCA.',
          'Pilih menu Transfer → ke BCA Virtual Account.',
          'Masukkan nomor VA di atas lalu konfirmasi.',
          'Masukkan nominal ${_formatRp(widget.amount)} lalu transfer.',
        ];
      case 'MDR':
        return [
          'Buka aplikasi Livin\' by Mandiri.',
          'Pilih Transfer → Mandiri Virtual Account.',
          'Masukkan nomor VA lalu lanjutkan.',
          'Konfirmasi dan selesaikan pembayaran.',
        ];
      case 'BRI':
        return [
          'Buka BRImo atau akses Internet Banking BRI.',
          'Pilih Pembayaran → BRIVA.',
          'Masukkan nomor VA dan nominal.',
          'Konfirmasi dengan PIN/token.',
        ];
      default:
        return [
          'Buka aplikasi mobile banking $bank.',
          'Pilih menu Transfer → Virtual Account.',
          'Masukkan nomor VA di atas.',
          'Konfirmasi nominal dan selesaikan pembayaran.',
        ];
    }
  }
}

class _VaBank {
  final String shortName;
  final String fullName;
  final int color;
  final String prefix;
  const _VaBank(this.shortName, this.fullName, this.color, this.prefix);
}
