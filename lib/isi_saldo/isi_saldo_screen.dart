import 'package:flutter/material.dart';
import 'va_bank_screen.dart';
import 'transfer_manual_screen.dart';
import 'minimarket_screen.dart';
import '/shared/thousands_formatter.dart';

class IsiSaldoScreen extends StatefulWidget {
  const IsiSaldoScreen({super.key});

  @override
  State<IsiSaldoScreen> createState() => _IsiSaldoScreenState();
}

class _IsiSaldoScreenState extends State<IsiSaldoScreen> {
  static const List<int> _quickAmounts = [
    20000, 50000, 100000, 200000, 500000, 1000000
  ];

  int? _selectedAmount;
  final _customController = TextEditingController();
  bool _useCustom = false;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  int get _finalAmount {
    if (_useCustom) {
      return int.tryParse(_customController.text.replaceAll('.', '')) ?? 0;
    }
    return _selectedAmount ?? 0;
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

  void _proceed(BuildContext context, String method) {
    final amount = _finalAmount;
    if (amount < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal top up Rp 10.000')),
      );
      return;
    }
    switch (method) {
      case 'va':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VaBankScreen(amount: amount)),
        );
      case 'manual':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TransferManualScreen(amount: amount)),
        );
      case 'minimarket':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MinimarketScreen(amount: amount)),
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
          'Isi Saldo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pilih Nominal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
          ),
          const SizedBox(height: 14),

          // Quick amount grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 2.4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: _quickAmounts.map((amount) {
              final selected = !_useCustom && _selectedAmount == amount;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedAmount = amount;
                  _useCustom = false;
                  _customController.clear();
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF0040A1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? const Color(0xFF0040A1) : Colors.grey.shade200,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formatRp(amount),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Custom amount
          GestureDetector(
            onTap: () => setState(() {
              _useCustom = true;
              _selectedAmount = null;
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _useCustom ? const Color(0xFF0040A1) : Colors.grey.shade200,
                  width: _useCustom ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Rp',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _useCustom ? const Color(0xFF0040A1) : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _customController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsSeparatorFormatter()],
                      onTap: () => setState(() {
                        _useCustom = true;
                        _selectedAmount = null;
                      }),
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        hintText: 'Nominal lainnya',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_finalAmount > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Top up: ${_formatRp(_finalAmount)}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 28),

          const Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
          ),
          const SizedBox(height: 14),

          // Transfer Virtual Account
          _MethodSection(
            title: 'Virtual Account (VA)',
            subtitle: 'Transfer via ATM, mobile banking, atau internet banking',
            icon: Icons.account_balance,
            iconColor: const Color(0xFF0040A1),
            iconBg: const Color(0xFF0040A1),
            banks: const [
              _BankOption(name: 'BCA Virtual Account', logo: 'BCA', color: 0xFF003087),
              _BankOption(name: 'Mandiri Virtual Account', logo: 'MDR', color: 0xFF0066AE),
              _BankOption(name: 'BRI Virtual Account', logo: 'BRI', color: 0xFF00529B),
              _BankOption(name: 'BNI Virtual Account', logo: 'BNI', color: 0xFF004B87),
              _BankOption(name: 'CIMB Virtual Account', logo: 'CMB', color: 0xFF7B0000),
              _BankOption(name: 'Permata Virtual Account', logo: 'PMT', color: 0xFF003A70),
            ],
            onBankTap: (bank) => _proceed(context, 'va'),
          ),
          const SizedBox(height: 16),

          // Transfer Manual
          _MethodSection(
            title: 'Transfer Bank Manual',
            subtitle: 'Transfer ke rekening TCPay, saldo otomatis bertambah',
            icon: Icons.swap_horiz,
            iconColor: const Color(0xFF8A5100),
            iconBg: const Color(0xFFFE9800),
            banks: const [
              _BankOption(name: 'BCA', logo: 'BCA', color: 0xFF003087),
              _BankOption(name: 'Mandiri', logo: 'MDR', color: 0xFF0066AE),
              _BankOption(name: 'BRI', logo: 'BRI', color: 0xFF00529B),
              _BankOption(name: 'BNI', logo: 'BNI', color: 0xFF004B87),
            ],
            onBankTap: (bank) => _proceed(context, 'manual'),
          ),
          const SizedBox(height: 16),

          // Minimarket
          _MethodCardSimple(
            title: 'Minimarket',
            subtitle: 'Bayar di kasir Alfamart atau Indomaret',
            icon: Icons.store,
            iconColor: Colors.green.shade700,
            iconBg: Colors.green.shade50,
            tags: const ['Alfamart', 'Indomaret'],
            onTap: () => _proceed(context, 'minimarket'),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _BankOption {
  final String name;
  final String logo;
  final int color;
  const _BankOption({required this.name, required this.logo, required this.color});
}

class _MethodSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<_BankOption> banks;
  final void Function(_BankOption bank) onBankTap;

  const _MethodSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.banks,
    required this.onBankTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconBg, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...banks.map((bank) => InkWell(
                onTap: () => onBankTap(bank),
                borderRadius: BorderRadius.vertical(
                  bottom: bank == banks.last ? const Radius.circular(20) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Color(bank.color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            bank.logo,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(bank.color),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(bank.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _MethodCardSimple extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<String> tags;
  final VoidCallback onTap;

  const _MethodCardSimple({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.tags,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 8),
                      ...tags.map((t) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(t, style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                          )),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
