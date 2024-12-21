import 'package:async/async.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/api/endpoints.dart';
import 'package:gymm/models/invitation.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/colors.dart';
import 'error_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvitationTile extends StatefulWidget {
  final Invitation invitation;
  final Future<void> Function()? callback;

  const InvitationTile({super.key, required this.invitation, this.callback});

  @override
  State<InvitationTile> createState() => _InvitationTileState();
}

class _InvitationTileState extends State<InvitationTile> {
  bool _deleting = false;
  bool submitting = false;

  CancelableOperation? _currentOperation;

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _deleteInvitation() async {
    if (_deleting) return;
    setState(() {
      _deleting = true;
    });

    _currentOperation?.cancel();
    _currentOperation =
        CancelableOperation.fromFuture(deleteInvitation(widget.invitation.id));

    _currentOperation!.value.then((value) {
      if (!mounted) return;
      showSnackBar(
          context, AppLocalizations.of(context)!.invitationDeleted, "info");
      if (widget.callback != null) {
        widget.callback!();
      }
    }).catchError((e) {
      showSnackBar(context,
          AppLocalizations.of(context)!.failedDeletingInvitation, "error");
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    });
  }

  void _deleteInvitationDialog() async {
    final bool? result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "${AppLocalizations.of(context)!.deleteInvitation} ${widget.invitation.code}?",
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 44,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.delete,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[500],
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ));

    if (result == true) {
      await _deleteInvitation();
    }
  }

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
            data: widget.invitation.code,
            barcode: Barcode.code128(),
            width: 190,
            height: 160,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            drawText: false,
            errorBuilder: (context, str) => errorWidget(context),
          ),
        ),
        title: Text(widget.invitation.code,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        subtitle: Text(
            widget.invitation.isValid
                ? AppLocalizations.of(context)!.valid
                : AppLocalizations.of(context)!.used,
            style: TextStyle(
                color: widget.invitation.isValid ? Colors.green : Colors.red,
                fontSize: 16)),
        trailing: widget.invitation.isValid || !_deleting
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                          text:
                              '${EndPoints.frontedBaseUrl}invitation-receipt/${widget.invitation.key}'));
                      showSnackBar(context,
                          AppLocalizations.of(context)!.linkCopied, "info");
                    },
                    icon: const Icon(Icons.copy, size: 30),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            '${EndPoints.frontedBaseUrl}invitation-receipt/${widget.invitation.key}');
                        await launchUrl(url);
                      },
                      icon: const Icon(Icons.remove_red_eye,
                          color: primaryColor, size: 30)),
                  const SizedBox(width: 15),
                  IconButton(
                      onPressed: () {
                        _deleteInvitationDialog();
                      },
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 30))
                ],
              )
            : null,
      ),
    );
  }
}
