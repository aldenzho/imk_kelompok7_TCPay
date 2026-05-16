import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/services/wallet_service.dart';

class TransferManualScreen extends StatefulWidget {
  final int amount;
  const TransferManualScreen({super.key, required this.amount});

  @override
  State<TransferManualScreen> createState() => _TransferManualScreenState();
}

class _TransferManualScreenState extends State<TransferManualScreen> {
  static const List<_BankInfo> _banks = [
    _BankInfo('BCA', 'BCA', 0xFF003087, '8100882100212', 'TCPay Indonesia'),
    _BankInfo('MDR', 'Mandiri', 0xFF0066AE, '1230009887651', 'TCPay Indonesia'),
    _BankInfo('BRI', 'BRI', 0xFF00529B, '0367010123456', 'TCPay Indonesia'),
    _BankInfo('BNI', 'BNI', 0xFF004B87, '0712345678', 'TCPay Indonesia'),
  ];

  int _selectedIndex = 0;
  bool _isConfirming = false;

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
        method: 'Transfer ${_banks[_selectedIndex].bankName}',
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

  @override
  Widget build(BuildContext context) {
    final bank = _banks[_selectedIndex];
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
          'Transfer Bank Manual',
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
                const Text('Nominal Transfer', style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(
                  _formatRp(widget.amount),
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Pilih Bank Tujuan',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_banks.length, (i) {
              final b = _banks[i];
              final selected = i == _selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    margin: EdgeInsets.only(right: i < _banks.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF0040A1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? const Color(0xFF0040A1) : Colors.grey.shade200,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: selected ? Colors.white.withValues(alpha: 0.2) : Color(b.color).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              b.shortName,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: selected ? Colors.white : Color(b.color),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b.bankName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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

          // Account details card
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
                        color: Color(bank.color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          bank.shortName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(bank.color),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rekening ${bank.bankName}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const Text('Atas Nama', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _accountRow('Nama Penerima', bank.accountHolder),
                const Divider(height: 20),
                _copyRow('Nomor Rekening', bank.accountNumber),
                const Divider(height: 20),
                _copyRow('Nominal Transfer', _formatRp(widget.amount)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF8A5100), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Transfer TEPAT sesuai nominal di atas agar saldo otomatis bertambah dalam 1-5 menit.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF8A5100), height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cara Transfer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 10),
                ..._transferSteps(bank.bankName).asMap().entries.map((e) => Padding(
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
                      _isConfirming ? 'Memproses...' : 'Simulasikan Transfer Berhasil',
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
                    '(Tombol ini hanya untuk demo — di produksi saldo bertambah otomatis)',
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

  Widget _accountRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _copyRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Row(
          children: [
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0040A1))),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label disalin')),
                );
              },
              child: const Icon(Icons.copy, size: 16, color: Color(0xFF0040A1)),
            ),
          ],
        ),
      ],
    );
  }

  List<String> _transferSteps(String bank) {
    switch (bank) {
      case 'BCA':
        return [
          'Buka aplikasi BCA Mobile atau akses KlikBCA.',
          'Pilih Transfer → ke Rekening BCA.',
          'Masukkan nomor rekening TCPay di atas.',
          'Masukkan nominal TEPAT ${_formatRp(widget.amount)}.',
          'Konfirmasi dan selesaikan transfer.',
        ];
      case 'Mandiri':
        return [
          'Buka aplikasi Livin\' by Mandiri.',
          'Pilih Transfer → ke Rekening Mandiri.',
          'Masukkan nomor rekening TCPay di atas.',
          'Masukkan nominal TEPAT ${_formatRp(widget.amount)}.',
          'Konfirmasi dengan PIN Mandiri.',
        ];
      case 'BRI':
        return [
          'Buka BRImo atau Internet Banking BRI.',
          'Pilih Transfer → Sesama BRI.',
          'Masukkan nomor rekening TCPay di atas.',
          'Masukkan nominal TEPAT ${_formatRp(widget.amount)}.',
          'Konfirmasi dengan PIN BRI.',
        ];
      default:
        return [
          'Buka aplikasi mobile banking $bank.',
          'Pilih Transfer Antar Bank.',
          'Masukkan nomor rekening TCPay di atas.',
          'Masukkan nominal TEPAT ${_formatRp(widget.amount)}.',
          'Konfirmasi dan selesaikan transfer.',
        ];
    }
  }
}

class _BankInfo {
  final String shortName;
  final String bankName;
  final int color;
  final String accountNumber;
  final String accountHolder;
  const _BankInfo(this.shortName, this.bankName, this.color, this.accountNumber, this.accountHolder);
}
