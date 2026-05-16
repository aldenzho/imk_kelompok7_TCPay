import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/services/wallet_service.dart';

class MinimarketScreen extends StatefulWidget {
  final int amount;
  const MinimarketScreen({super.key, required this.amount});

  @override
  State<MinimarketScreen> createState() => _MinimarketScreenState();
}

class _MinimarketScreenState extends State<MinimarketScreen> {
  static const List<_MinimarketInfo> _stores = [
    _MinimarketInfo('Alfamart', Icons.store, 0xFF003087, Color(0xFFE8F0FF)),
    _MinimarketInfo('Indomaret', Icons.storefront, 0xFFCC0000, Color(0xFFFFEBEB)),
  ];

  int _selectedStore = 0;
  bool _isConfirming = false;

  String get _paymentCode {
    final prefix = _selectedStore == 0 ? '70011' : '70012';
    final unique = (widget.amount % 10000).toString().padLeft(4, '0');
    return '${prefix}882100$unique';
  }

  String _formatRp(int val) {
    final str = val.toString();
    final buf = StringBuffer('Rp ');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  Future<void> _simulateConfirm() async {
    setState(() => _isConfirming = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    try {
      await WalletService().topUpBalance(
        amount: widget.amount,
        method: _stores[_selectedStore].name,
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
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  String _expiryTime() {
    final exp = DateTime.now().add(const Duration(hours: 24));
    return '${exp.day.toString().padLeft(2, '0')}/${exp.month.toString().padLeft(2, '0')}/${exp.year} '
        '${exp.hour.toString().padLeft(2, '0')}:${exp.minute.toString().padLeft(2, '0')} WIB';
  }

  @override
  Widget build(BuildContext context) {
    final store = _stores[_selectedStore];
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
          'Bayar di Minimarket',
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
                const Text('Nominal Top Up', style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(
                  _formatRp(widget.amount),
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Pilih Minimarket',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_stores.length, (i) {
              final s = _stores[i];
              final selected = i == _selectedStore;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedStore = i),
                  child: Container(
                    margin: EdgeInsets.only(right: i == 0 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF0040A1) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? const Color(0xFF0040A1) : Colors.grey.shade200,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          s.icon,
                          color: selected ? Colors.white : Color(s.color),
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Payment code card
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
                        color: store.bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(store.icon, color: Color(store.color), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const Text('Kode Pembayaran', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Payment code display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _paymentCode,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: Color(0xFF0040A1),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Color(0xFF0040A1)),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _paymentCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kode pembayaran disalin')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                _infoRow('Total Bayar', _formatRp(widget.amount)),
                const SizedBox(height: 8),
                _infoRow('Berlaku sampai', _expiryTime()),
                const SizedBox(height: 16),

                // Steps
                const Text(
                  'Cara Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 10),
                ..._steps(store.name).asMap().entries.map((e) => Padding(
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
                                '${e.key + 1}',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(e.value, style: const TextStyle(fontSize: 13, height: 1.4)),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isConfirming ? null : _simulateConfirm,
                    icon: _isConfirming
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check_circle_outline, color: Colors.white),
                    label: Text(
                      _isConfirming ? 'Memproses...' : 'Simulasikan Pembayaran Berhasil',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    '(Tombol ini hanya untuk demo — di produksi kasir konfirmasi secara otomatis)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
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

  List<String> _steps(String store) {
    if (store == 'Alfamart') {
      return [
        'Datang ke gerai Alfamart terdekat.',
        'Sampaikan ke kasir bahwa Anda ingin top up TCPay.',
        'Berikan kode pembayaran di atas kepada kasir.',
        'Bayar sejumlah ${_formatRp(widget.amount)} secara tunai.',
        'Simpan struk sebagai bukti pembayaran.',
      ];
    } else {
      return [
        'Datang ke gerai Indomaret terdekat.',
        'Sampaikan ke kasir bahwa Anda ingin top up TCPay.',
        'Berikan kode pembayaran di atas kepada kasir.',
        'Bayar sejumlah ${_formatRp(widget.amount)} secara tunai.',
        'Saldo akan bertambah dalam 1-5 menit setelah pembayaran.',
      ];
    }
  }
}

class _MinimarketInfo {
  final String name;
  final IconData icon;
  final int color;
  final Color bgColor;
  const _MinimarketInfo(this.name, this.icon, this.color, this.bgColor);
}
