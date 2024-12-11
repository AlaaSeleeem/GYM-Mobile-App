import 'package:flutter/material.dart';
import 'package:gymm/components/store_components/action_buttons.dart';
import 'package:gymm/components/store_components/categories_tiles.dart';
import 'package:gymm/components/store_components/products_list.dart';
import 'package:gymm/components/store_components/products_search_bar.dart';
import 'package:gymm/models/product.dart';
import '../models/category.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String _category = "All";

  @override
  Widget build(BuildContext context) {
    final List<Category> categoriesList = [
      Category(name: "biscuits", id: 1),
      Category(name: "Supplements", id: 2),
      Category(name: "supp", id: 3),
      Category(name: "protein", id: 4),
      Category(name: "keratin", id: 5),
      Category(name: "choco bars", id: 6),
      Category(name: "drinks", id: 7),
    ];

    final TextEditingController searchController = TextEditingController();

    void onSearch() {
      final searchQuery = searchController.text.trim();
      print("Searching for: $searchQuery");
    }

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {},
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 50, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductsSearchBar(
                        searchController: searchController, onSearch: onSearch),
                    const SizedBox(
                      height: 20,
                    ),
                    CategoriesTiles(
                      currentCategory: _category,
                      categoriesList: categoriesList,
                      onCategoryChanged: (category) {
                        setState(() {
                          _category = category;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    ProductsList(
                        productList: List.generate(12, (index) {
                      return Product.fromJson({
                        "id": index,
                        "discount": 10,
                        "category": "supplements",
                        "name": "Test Product",
                        "description":
                            "To make the text wrap within its parent container when the width shrinks, you can use a Flexible or Expanded widget around the Text widgets inside the Row. These widgets allow their children to adapt to the available space by wrapping text if needed. To make the text wrap within its parent container when the width shrinks, you can use a Flexible or Expanded widget around the Text widgets inside the Row. These widgets allow their children to adapt to the available space by wrapping text if needed. To make the text wrap within its parent container when the width shrinks, you can use a Flexible or Expanded widget around the Text widgets inside the Row. These widgets allow their children to adapt to the available space by wrapping text if needed. To make the text wrap within its parent container when the width shrinks, you can use a Flexible or Expanded widget around the Text widgets inside the Row. These widgets allow their children to adapt to the available space by wrapping text if needed. To make the text wrap within its parent container when the width shrinks, you can use a Flexible or Expanded widget around the Text widgets inside the Row. These widgets allow their children to adapt to the available space by wrapping text if needed. To make the text wrap within its parent container when the width shrinks, you can use a Flexible or Expanded widget around the Text widgets inside the Row. These widgets allow their children to adapt to the available space by wrapping text if needed. To make the text wrap within its parent container when the width shrinks, you can use a Flexible or Expanded widget around the Text widgets inside the Row. These widgets allow their children to adapt to the available space by wrapping text if needed.",
                        "sell_price": "1200.00",
                        "cost_price": "1000.00",
                        "stock": 0,
                        "image":
                            "http://10.0.2.2:8000/media/products/product1.jpg",
                        "created_at": "2024-12-02T16:19:51.953150+02:00",
                        "updated_at": "2024-12-10T13:15:13.997178+02:00"
                      });
                    }))
                  ],
                ),
              ),
            ),
          ),
          const Positioned(bottom: 16, right: 8, child: ActionButtons()),
        ],
      ),
    );
  }
}
