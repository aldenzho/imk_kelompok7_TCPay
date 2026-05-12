import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/bank_account_model.dart';
import 'withdrawal_amount_screen.dart';

class WithdrawalSelectBankScreen extends StatefulWidget {
  const WithdrawalSelectBankScreen({super.key});

  @override
  State<WithdrawalSelectBankScreen> createState() => _WithdrawalSelectBankScreenState();
}

class _WithdrawalSelectBankScreenState extends State<WithdrawalSelectBankScreen> {
  BankAccount? _selectedAccount;
  bool _showNewForm = false;
  bool _isVerifying = false;
  bool _isVerified = false;

  String? _selectedBank;
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  Future<void> _verifyAccount() async {
    if (_selectedBank == null || _accountNumberController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi nomor rekening terlebih dahulu')),
      );
      return;
    }
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isVerifying = false;
      _isVerified = true;
      _accountHolderController.text = 'Abimanyu Danendra A.';
    });
  }

  void _onLanjutkan() {
    BankAccount? target = _selectedAccount;
    if (_showNewForm && _isVerified && _selectedBank != null) {
      target = BankAccount(
        bankName: _selectedBank!,
        accountNumber: _accountNumberController.text,
        accountHolder: _accountHolderController.text,
        logoInitials: _selectedBank!.substring(0, _selectedBank!.length.clamp(0, 3)),
        logoColor: 0xFF0040A1,
      );
    }
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih rekening tujuan terlebih dahulu')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WithdrawalAmountScreen(bankAccount: target!)),
    );
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
          'Tarik Tunai ke Bank',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Rekening Tersimpan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
                ),
                const SizedBox(height: 12),
                ...BankAccount.mockAccounts.map((account) => _SavedAccountCard(
                      account: account,
                      isSelected: _selectedAccount == account,
                      onTap: () => setState(() {
                        _selectedAccount = account;
                        _showNewForm = false;
                      }),
                    )),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ATAU', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => setState(() {
                    _showNewForm = !_showNewForm;
                    _selectedAccount = null;
                    _isVerified = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _showNewForm
                          ? const Color(0xFF0040A1).withValues(alpha: 0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _showNewForm
                            ? const Color(0xFF0040A1)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline, color: Color(0xFF0040A1)),
                        const SizedBox(width: 12),
                        const Text(
                          'Tambah Rekening Baru',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0040A1)),
                        ),
                        const Spacer(),
                        Icon(
                          _showNewForm ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showNewForm) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pilih Bank', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedBank,
                          hint: const Text('Pilih bank tujuan'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: BankAccount.allBankNames
                              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                              .toList(),
                          onChanged: (val) => setState(() {
                            _selectedBank = val;
                            _isVerified = false;
                            _accountHolderController.clear();
                          }),
                        ),
                        const SizedBox(height: 12),
                        const Text('Nomor Rekening', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _accountNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (_) => setState(() => _isVerified = false),
                          decoration: InputDecoration(
                            hintText: 'Masukkan nomor rekening',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_isVerified) ...[
                          const Text('Nama Pemilik', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _accountHolderController,
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              suffixIcon: const Icon(Icons.check_circle, color: Colors.green),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isVerifying ? null : _verifyAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0040A1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: _isVerifying
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    _isVerified ? 'Terverifikasi ✓' : 'Verifikasi Rekening',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_selectedAccount != null || (_showNewForm && _isVerified))
                    ? _onLanjutkan
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE9800),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedAccountCard extends StatelessWidget {
  final BankAccount account;
  final bool isSelected;
  final VoidCallback onTap;

  const _SavedAccountCard({
    required this.account,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0040A1) : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(account.logoColor).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    account.logoInitials,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(account.logoColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.bankName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(
                      '${account.maskedNumber} • ${account.accountHolder}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFF0040A1))
              else
                const Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
