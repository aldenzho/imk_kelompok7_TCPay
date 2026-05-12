import 'package:flutter/material.dart';
import '/models/tcpay_contact.dart';
import 'tcpay_amount_screen.dart';

class TcPaySearchScreen extends StatefulWidget {
  const TcPaySearchScreen({super.key});

  @override
  State<TcPaySearchScreen> createState() => _TcPaySearchScreenState();
}

class _TcPaySearchScreenState extends State<TcPaySearchScreen> {
  final _searchController = TextEditingController();
  List<TcPayContact> _filtered = TcPayContact.mockContacts;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = TcPayContact.mockContacts
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.phoneNumber.contains(query) ||
              c.tcpayId.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
          'Transfer Sesama TCPay',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: const InputDecoration(
                  hintText: 'Cari nama, nomor HP, atau TCPay ID',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _searchController.text.isEmpty ? 'Kontak Terakhir' : 'Hasil Pencarian',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('Kontak tidak ditemukan', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final contact = _filtered[index];
                      return _ContactTile(
                        contact: contact,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TcPayAmountScreen(recipient: contact),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final TcPayContact contact;
  final VoidCallback onTap;

  const _ContactTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF0040A1).withValues(alpha: 0.1),
                child: Text(
                  contact.initials,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 3),
                    Text(
                      '${contact.phoneNumber} • ${contact.tcpayId}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
