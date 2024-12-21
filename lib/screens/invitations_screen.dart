import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/api/exceptions.dart';
import 'package:gymm/components/invitation_tile.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/models/invitation.dart';
import 'package:gymm/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymm/utils/globals.dart';
import '../utils/snack_bar.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key, required this.subId});

  final int subId;

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  bool loading = false;
  bool submitting = false;

  late List<Invitation> _invitations = [];
  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _loadInvitations() async {
    if (loading) return;
    setState(() {
      _invitations = [];
      loading = true;
    });

    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(
        getSubscriptionInvitations(widget.subId));

    _currentOperation!.value.then((value) {
      if (!mounted) return;

      final List<Invitation> newInvitations = value;
      setState(() {
        _invitations.addAll(newInvitations);
      });
    }).catchError((e) {
      showSnackBar(context,
          AppLocalizations.of(context)!.failedLoadingInvitations, "error");
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  Future<void> _createInvitation() async {
    if (loading || submitting) return;
    setState(() {
      submitting = true;
    });

    _currentOperation?.cancel();
    _currentOperation =
        CancelableOperation.fromFuture(createInvitation(widget.subId));

    _currentOperation!.value.then((value) {
      if (mounted) {
        showSnackBar(
            context, AppLocalizations.of(context)!.invitationCreated, "info");
        _loadInvitations();
      }
    }).catchError((e) {
      if (e is ClientErrorException && e.statusCode == 400) {
        showSnackBar(context, e.responseBody["error"], "error");
      } else {
        showSnackBar(context,
            AppLocalizations.of(context)!.failedCreatingInvitation, "error");
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          submitting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.invitations),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: isArabic(context) ? 0 : 8.0,
                left: isArabic(context) ? 8.0 : 0),
            child: IconButton(
                onPressed: submitting
                    ? null
                    : () {
                        _createInvitation();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor[900],
                  padding: const EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: submitting
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        width: 40,
                        height: 40,
                        child: const CircularProgressIndicator())
                    : const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      )),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadInvitations,
        child: loading
            ? const Loading(height: 100)
            : LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: constraints.maxHeight + 0.01),
                      child: Column(
                        children: _invitations.isEmpty
                            ? [
                                const SizedBox(height: 20),
                                Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.noInvitations,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 24),
                                ))
                              ]
                            : _invitations
                                .map((inv) => InvitationTile(
                                      invitation: inv,
                                      callback: _loadInvitations,
                                    ))
                                .toList(),
                      )),
                ),
              ),
      ),
    );
  }
}
