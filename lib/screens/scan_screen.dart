import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/theme/colors.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String code = "Barcode";

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, minWidth: double.infinity),
              child: SizedBox(
                child: Flex(
                  direction: isLandscape ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: isLandscape
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    if (!isLandscape)
                      Image.asset('assets/logo1.jpeg', height: 150),
                    const SizedBox(height: 20),
                    Text(
                      code,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 45),
                    Column(
                      children: [
                        IntrinsicWidth(
                          child: IntrinsicHeight(
                            child: Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: primaryColor, width: 6),
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.asset(
                                    code == "Barcode"
                                        ? 'assets/parcode.jfif'
                                        : 'assets/img_1.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 20),
                        // const Text(
                        //   'Scan code to enter',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 2, color: primaryColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeInOut,
                              left: code == "Barcode" ? 4 : 74,
                              child: Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              height: 55,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          code = "Barcode";
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.barcode,
                                        color: code == "Barcode"
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          code = "Qr-code";
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent),
                                      child: Icon(FontAwesomeIcons.qrcode,
                                          color: code == "Qr-code"
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
