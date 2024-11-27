import 'package:flutter/material.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/theme/colors.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key, required this.client});

  final Client client;

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  @override
  Widget build(BuildContext context) {
    final client = widget.client;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: blackColor[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildRow(
                  icon: Icons.person_rounded, title: "ID", value: client.id!),
              _buildRow(
                  icon: Icons.credit_card,
                  title: "National",
                  value: client.nationalId),
              _buildRow(
                  icon: Icons.phone_android,
                  title: "Phone",
                  value: client.phone),
              _buildRow(
                  icon: Icons.phone_android,
                  title: "Phone 2",
                  value: client.phone2),
              _buildRow(
                  icon: Icons.male, title: "Gander", value: client.gender),
              _buildRow(
                  icon: Icons.calendar_month,
                  title: "Birth Date",
                  value: client.birthDate != null
                      ? "${client.birthDate!.day} - ${client.birthDate!.month} - ${client.birthDate!.year}"
                      : null),
              _buildRow(
                  icon: Icons.numbers,
                  title: "Age",
                  value: client.age?.toString()),
              _buildRow(icon: Icons.email, title: "Email", value: client.email),
              _buildRow(
                  icon: Icons.house, title: "Address", value: client.address),
              _buildRow(
                  icon: Icons.directions_run,
                  title: "Weight",
                  value: client.weight?.toString()),
              _buildRow(
                  icon: Icons.height,
                  title: "Height",
                  value: client.height?.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

TableRow _buildRow(
    {required IconData icon, required String title, required String? value}) {
  bool noValue = value == null || value.isEmpty;
  return TableRow(
    children: [
      SizedBox(
        height: 40,
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 24),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
      SizedBox(
          height: 40,
          child: Row(
            children: [
              Text(noValue ? "unset" : value,
                  style: TextStyle(
                      color: noValue ? Colors.red[500] : Colors.white,
                      fontSize: 18)),
            ],
          )),
    ],
  );
}
