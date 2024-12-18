import 'package:flutter/material.dart';
import 'package:gymm/components/invitation_tile.dart';
import 'package:gymm/models/invitation.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  bool submitting = false;
  final List<Invitation> invitations = [
    Invitation(
        id: 1, isUsed: false, createdAt: DateTime.now(), code: 'INV12345'),
    Invitation(
        id: 2, isUsed: true, createdAt: DateTime.now(), code: 'INV67890'),
    Invitation(
        id: 3, isUsed: true, createdAt: DateTime.now(), code: 'INV67898'),
    Invitation(
        id: 4, isUsed: false, createdAt: DateTime.now(), code: 'INV67834'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invitations')),
      body: ListView.separated(
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          final invitation = invitations[index];
          return InvitationTile(invitation: invitation);
        },
        separatorBuilder: (context, index) =>
            const Divider(thickness: 1, color: Colors.grey, height: 1),
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
