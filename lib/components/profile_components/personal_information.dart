import 'package:flutter/material.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/screens/edit_personal_info_screen.dart';
import 'package:gymm/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.personalInfo,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const EditPersonalInfoPage()));
                },
                icon: const Icon(Icons.edit, color: primaryColor),
                padding: EdgeInsets.zero,
              )
            ],
          ),
          const SizedBox(height: 15),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildRow(
                  icon: Icons.person_rounded,
                  title: AppLocalizations.of(context)!.id,
                  value: client.id!),
              _buildRow(
                  icon: Icons.credit_card,
                  title: AppLocalizations.of(context)!.nationalId,
                  value: client.nationalId),
              _buildRow(
                  icon: Icons.phone_android,
                  title: AppLocalizations.of(context)!.phone,
                  value: client.phone),
              _buildRow(
                  icon: Icons.phone_android,
                  title: AppLocalizations.of(context)!.phone2,
                  value: client.phone2),
              _buildRow(
                  icon: Icons.male,
                  title: AppLocalizations.of(context)!.gander,
                  value: client.gender),
              _buildRow(
                  icon: Icons.calendar_month,
                  title: AppLocalizations.of(context)!.birthdate,
                  value: client.birthDateString()),
              _buildRow(
                  icon: Icons.numbers,
                  title: AppLocalizations.of(context)!.age,
                  value: client.age?.toString()),
              _buildRow(
                  icon: Icons.email,
                  title: AppLocalizations.of(context)!.email,
                  value: client.email),
              _buildRow(
                  icon: Icons.house,
                  title: AppLocalizations.of(context)!.address,
                  value: client.address),
              _buildRow(
                  icon: Icons.directions_run,
                  title: AppLocalizations.of(context)!.weight,
                  value: client.weight?.toString()),
              _buildRow(
                  icon: Icons.height,
                  title: AppLocalizations.of(context)!.height,
                  value: client.height?.toString()),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildRow(
      {required IconData icon, required String title, String? value}) {
    bool noValue = value == null || value.isEmpty;
    return TableRow(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Icon(icon, color: primaryColor, size: 24),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 50),
          child: Row(
            children: [
              Expanded(
                child: Text(
                    noValue ? AppLocalizations.of(context)!.unset : value,
                    softWrap: true,
                    style: TextStyle(
                        color: noValue ? Colors.red[500] : Colors.white,
                        fontSize: 18)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
