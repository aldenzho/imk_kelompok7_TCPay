class TcPayContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String tcpayId;
  final String initials;

  const TcPayContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.tcpayId,
    required this.initials,
  });

  static const List<TcPayContact> mockContacts = [
    TcPayContact(
      id: '1',
      name: 'Aiden Zhorif Muhammad',
      phoneNumber: '0812-3456-7890',
      tcpayId: 'TCPAY-001',
      initials: 'AZ',
    ),
    TcPayContact(
      id: '2',
      name: 'Rusdi Anto',
      phoneNumber: '0813-9988-7766',
      tcpayId: 'TCPAY-002',
      initials: 'RA',
    ),
    TcPayContact(
      id: '3',
      name: 'Siti Rahayu',
      phoneNumber: '0857-1122-3344',
      tcpayId: 'TCPAY-003',
      initials: 'SR',
    ),
    TcPayContact(
      id: '4',
      name: 'Budi Santoso',
      phoneNumber: '0821-5544-3322',
      tcpayId: 'TCPAY-004',
      initials: 'BS',
    ),
    TcPayContact(
      id: '5',
      name: 'Dinda Aulia Putri',
      phoneNumber: '0878-6677-5544',
      tcpayId: 'TCPAY-005',
      initials: 'DA',
    ),
  ];
}
