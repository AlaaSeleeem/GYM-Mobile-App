import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget errorWidget(BuildContext context) => SizedBox(
      width: 240,
      height: 240,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.oops,
          style: TextStyle(
              color: Colors.red[600],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
