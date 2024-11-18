import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart'; // استيراد المكتبة
import 'navbar.dart';

class Invitation {
  final String code;
  bool isUsed;

  Invitation({required this.code, this.isUsed = false});
}

class SubscriptionDetails {
  final String subscriptionName;
  final String subscriptionCode;
  final DateTime startDate;
  final DateTime endDate;
  final int totalInvitations;
  int usedInvitations;
  List<Invitation> invitations;

  SubscriptionDetails({
    required this.subscriptionName,
    required this.subscriptionCode,
    required this.startDate,
    required this.endDate,
    required this.totalInvitations,
    required this.usedInvitations,
  }) : invitations = [];
}

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool _isQRCode = true;
  int _selectedSubscriptionIndex = 0;

  final List<SubscriptionDetails> _subscriptions = [
    SubscriptionDetails(
      subscriptionName: "Premium Membership",
      subscriptionCode: "PREM1234",
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2025, 1, 1),
      totalInvitations: 5,
      usedInvitations: 2,
    ),
    SubscriptionDetails(
      subscriptionName: "Basic Membership",
      subscriptionCode: "BASIC5678",
      startDate: DateTime(2023, 6, 1),
      endDate: DateTime(2024, 6, 1),
      totalInvitations: 3,
      usedInvitations: 1,
    ),
  ];

  void _showSubscriptionDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _subscriptionDetails = _subscriptions[_selectedSubscriptionIndex];

            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text('Subscription Details', style: TextStyle(color: Colors.yellow)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<int>(
                      value: _selectedSubscriptionIndex,
                      dropdownColor: Colors.grey[900], // تغيير لون القائمة المنسدلة هنا
                      items: List.generate(_subscriptions.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(
                            _subscriptions[index].subscriptionName,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedSubscriptionIndex = value!;
                        });
                      },
                    ),
                    _buildDetailRow(Icons.card_membership, 'Name:', _subscriptionDetails.subscriptionName),
                    _buildDetailRow(Icons.code, 'Code:', _subscriptionDetails.subscriptionCode),
                    _buildDetailRow(Icons.calendar_today, 'Start Date:', _subscriptionDetails.startDate.toLocal().toString().split(' ')[0]),
                    _buildDetailRow(Icons.calendar_today, 'End Date:', _subscriptionDetails.endDate.toLocal().toString().split(' ')[0]),
                    _buildDetailRow(Icons.card_giftcard, 'Total Invitations:', _subscriptionDetails.totalInvitations.toString()),
                    _buildDetailRow(Icons.check, 'Used Invitations:', _subscriptionDetails.usedInvitations.toString()),
                    if (_subscriptionDetails.endDate.isBefore(DateTime.now()))
                      Text('Subscription has expired', style: TextStyle(color: Colors.red)),
                    if (_subscriptionDetails.totalInvitations == 0 || _subscriptionDetails.usedInvitations >= _subscriptionDetails.totalInvitations)
                      Text('No invitations available', style: TextStyle(color: Colors.red)),
                    SizedBox(height: 20),
                    if (_subscriptionDetails.usedInvitations < _subscriptionDetails.totalInvitations)
                      ElevatedButton(
                        onPressed: () {
                          _createInvitation(setState);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                        child: Text('Create Invitation', style: TextStyle(color: Colors.black)),
                      ),
                    SizedBox(height: 20),
                    _buildInvitationsList(setState), // تمرير setState هنا
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.yellow)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.yellow),
        SizedBox(width: 8),
        Text('$title $value', style: TextStyle(color: Colors.white)),
      ],
    );
  }

  void _createInvitation(StateSetter setState) {
    final _subscriptionDetails = _subscriptions[_selectedSubscriptionIndex];
    if (_subscriptionDetails.invitations.length < _subscriptionDetails.totalInvitations) {
      String newCode = 'INV${_subscriptionDetails.invitations.length + 1}';
      setState(() {
        _subscriptionDetails.invitations.add(Invitation(code: newCode));
        _subscriptionDetails.usedInvitations++; // زيادة عدد الدعوات المستخدمة
      });
    }
  }

  void _showDeleteConfirmationDialog(Invitation invitation, StateSetter setState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Confirm Delete', style: TextStyle(color: Colors.yellow)),
          content: Text('Are you sure you want to delete ${invitation.code}?', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No', style: TextStyle(color: Colors.yellow)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final _subscriptionDetails = _subscriptions[_selectedSubscriptionIndex];
                  _subscriptionDetails.invitations.remove(invitation); // Remove the invitation
                  if (invitation.isUsed) {
                    _subscriptionDetails.usedInvitations--; // Decrease used invitations count
                  }
                });
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInvitationsList(StateSetter setState) {
    final _subscriptionDetails = _subscriptions[_selectedSubscriptionIndex];

    return Column(
      children: _subscriptionDetails.invitations.map((invitation) {
        return Card(
          color: Colors.grey[800],
          child: Container(
            width: 200, // ضبط العرض
            padding: EdgeInsets.all(8.0), // إضافة padding للحاوية
            child: Column(
              children: [
                Text(invitation.code, style: TextStyle(color: Colors.white, fontSize: 18)),
                Text(invitation.isUsed ? 'Used' : 'Available', style: TextStyle(color: Colors.yellow)),
                SizedBox(height: 10), // مسافة بين النص والأزرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.eye, color: Colors.blue),
                      onPressed: () {
                        // لا نفعل شيئًا هنا
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.copy, color: Colors.grey),
                      onPressed: () {
                        _copyInvitationLink(invitation.code); // استدعاء دالة النسخ
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.trash, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(invitation, setState); // تمرير setState هنا
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _copyInvitationLink(String code) {
    Clipboard.setData(ClipboardData(text: code)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation Code copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.yellow),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Scan QR Code',
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset('assets/logo1.jpeg', height: 120),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.asset('assets/logo1.jpeg', height: 150),
                SizedBox(height: 20),
                Text(
                  'Welcome to Pro Gym!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                SizedBox(height: 40),
                IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.yellow, width: 3),
                      ),
                      child: Center(
                        child: Image.asset(
                          _isQRCode ? 'assets/img_1.png' : 'assets/parcode.jfif',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Scan to Start',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isQRCode = !_isQRCode;
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isQRCode ? FontAwesomeIcons.barcode : FontAwesomeIcons.qrcode,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _isQRCode ? 'Switch to Barcode' : 'Switch to QR Code',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showSubscriptionDetailsDialog,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.envelope, color: Colors.black),
                      SizedBox(width: 8),
                      Text('View Subscription Details', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
        extendBody: true,
      ),
    );
  }
}
