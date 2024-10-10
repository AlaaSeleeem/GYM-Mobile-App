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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.yellow,
            ),
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
                Image.asset(
                  'logo1.jpeg',
                  height: 150,
                ),
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
                          fit: BoxFit.contain, // الحفاظ على نسبة الصورة
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
                // الزر لتغيير الصورة
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isQRCode = !_isQRCode; // تغيير الحالة عند الضغط
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
