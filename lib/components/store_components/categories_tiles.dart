import 'package:flutter/material.dart';
import 'package:gymm/models/category.dart';
import '../../theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesTiles extends StatefulWidget {
  const CategoriesTiles(
      {super.key,
      required this.currentCategory,
      required this.categoriesList,
      required this.onCategoryChanged});

  final String currentCategory;
  final List<Category> categoriesList;
  final Function(String) onCategoryChanged;

  @override
  State<CategoriesTiles> createState() => _CategoriesTilesState();
}

class _CategoriesTilesState extends State<CategoriesTiles> {
  late String _category;

  @override
  void initState() {
    super.initState();
    _category = widget.currentCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.categories,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const SizedBox(height: 12),
        Wrap(
          children: [
            // "All" Button
            InkWell(
              onTap: () {
                setState(() {
                  _category = "All";
                });
                widget.onCategoryChanged(_category);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: primaryColor),
                  color: _category == "All" ? primaryColor[500] : null,
                ),
                child: Text(
                  AppLocalizations.of(context)!.all,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Category Buttons
            ...widget.categoriesList.map((item) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _category = item.name;
                  });
                  widget.onCategoryChanged(_category);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: primaryColor),
                    color: _category == item.name ? primaryColor[500] : null,
                  ),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
