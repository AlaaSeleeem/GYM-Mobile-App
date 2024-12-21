import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;

  const ProductsSearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor[500]!, width: 1.2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.searchProducts,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none),
              onSubmitted: (value) {
                onSearch();
              },
            ),
          ),
          const SizedBox(width: 8),
          // Search Button
          IconButton(
            onPressed: onSearch,
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 26,
            ),
            tooltip: "Search",
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(primaryColor[500]),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)))),
          ),
        ],
      ),
    );
  }
}
