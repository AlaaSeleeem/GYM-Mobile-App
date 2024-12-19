import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../components/error_widget.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String code = "Barcode";
  String? id;

  @override
  void initState() {
    super.initState();
    _getClientID();
  }

  _getClientID() async {
    final client = await getClientSavedData();
    setState(() {
      id = client.id.toString();
    });
  }

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
                      code == "Barcode"
                          ? AppLocalizations.of(context)!.barcode
                          : AppLocalizations.of(context)!.qrcode,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(id ?? "",
                        style: TextStyle(
                            fontSize: 24,
                            color: blackColor[200],
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 35),
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
                                child: id != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        clipBehavior: Clip.antiAlias,
                                        child: code == "Barcode"
                                            ? BarcodeWidget(
                                                data: id!,
                                                barcode: Barcode.code128(),
                                                width: 220,
                                                height: 240,
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                drawText: true,
                                                errorBuilder: (context, str) =>
                                                    errorWidget,
                                              )
                                            : QrImageView(
                                                data: id!,
                                                version: QrVersions.auto,
                                                size: 240,
                                                errorStateBuilder:
                                                    (context, err) =>
                                                        errorWidget,
                                                embeddedImageEmitsError: true,
                                              ),
                                      )
                                    : const Loading(
                                        height: 240,
                                        width: 240,
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
