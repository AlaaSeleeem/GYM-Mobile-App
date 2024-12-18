import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/invitation_tile.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/models/invitation.dart';

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
      print(e);
      showSnackBar(context, "Failed loading invitations", "error");
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invitations')),
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
                            ? const [
                                SizedBox(height: 20),
                                Center(
                                    child: Text(
                                  "There aren't invitations for this subscription",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ))
                              ]
                            : _invitations
                                .map((inv) => InvitationTile(invitation: inv))
                                .toList(),
                      )),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitting
            ? null
            : () {
                // _saveForm(context);
              },
        child: submitting
            ? const Center(child: CircularProgressIndicator())
            : const Icon(
                Icons.add,
                size: 30,
              ),
      ),
    );
  }
}
