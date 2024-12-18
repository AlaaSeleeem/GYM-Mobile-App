import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymm/api/endpoints.dart';
import 'package:gymm/models/invitation.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/colors.dart';
import 'error_widget.dart';

class InvitationTile extends StatelessWidget {
  final Invitation invitation;

  const InvitationTile({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        tileColor: const Color(0xFF373739),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        leading: SizedBox(
          width: 70,
          height: 70,
          child: BarcodeWidget(
            data: invitation.code,
            barcode: Barcode.code128(),
            width: 190,
            height: 160,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            drawText: false,
            errorBuilder: (context, str) => errorWidget,
          ),
        ),
        title: Text(invitation.code,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        subtitle: Text(invitation.isUsed ? 'Used' : 'Valid',
            style: TextStyle(
                color: invitation.isUsed ? Colors.red : Colors.green,
                fontSize: 16)),
        trailing: !invitation.isUsed
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                          text:
                              '${EndPoints.frontedBaseUrl}invitation-receipt/${invitation.key}'));
                      showSnackBar(context,
                          "Invitation link copied to clipboard", "info");
                    },
                    icon: const Icon(Icons.copy, size: 30),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            '${EndPoints.frontedBaseUrl}invitation-receipt/${invitation.key}');
                        await launchUrl(url);
                      },
                      icon: const Icon(Icons.remove_red_eye,
                          color: primaryColor, size: 30)),
                  const SizedBox(width: 15),
                  IconButton(
                      onPressed: () {},
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 30))
                ],
              )
            : null,
      ),
    );
  }
}
