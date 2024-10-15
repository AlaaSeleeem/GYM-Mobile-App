import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'FINALbuttonNAVbar.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool _isQRCode = true; // حالة لتحديد إذا كنا نعرض QR أو باركود
  final TextEditingController _controller = TextEditingController();

  void _showInvitationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Send Invitation',
            style: TextStyle(color: Colors.yellow),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter email or phone number',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String input = _controller.text;
                      if (input.isNotEmpty) {
                        _sendInvitation(input); // استدعاء دالة إرسال الدعوة
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    child: Text('Send', style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // غلق الحوار
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.yellow)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendInvitation(String input) {
    // هنا يمكنك إضافة منطق إرسال الدعوة
    _showConfirmationDialog(input);
    _controller.clear(); // مسح النص بعد الإرسال
  }

  void _showConfirmationDialog(String input) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.check_circle, color: Colors.yellow, size: 40),
              ),
              SizedBox(height: 8),
              Text(
                'Invitation Sent',
                style: TextStyle(color: Colors.yellow),
              ),
            ],
          ),
          content: Text(
            '$input has been invited.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // غلق الحوار
              },
              child: Text('OK', style: TextStyle(color: Colors.yellow)),
            ),
          ],
        );
      },
    );
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
              child: Image.asset('logo1.jpeg', height: 120),
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
                Image.asset('logo1.jpeg', height: 150),
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
                          _isQRCode ? 'img_1.png' : 'parcode.jfif',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
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
                  onPressed: () {
                    _showInvitationDialog(); // عرض مربع الحوار
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Send Invitation',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottonNavBar(),
        extendBody: true,
      ),
    );
  }
}
