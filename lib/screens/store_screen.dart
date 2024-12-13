import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/components/store_components/action_buttons.dart';
import 'package:gymm/components/store_components/categories_tiles.dart';
import 'package:gymm/components/store_components/products_list.dart';
import 'package:gymm/components/store_components/products_search_bar.dart';
import 'package:gymm/models/product.dart';
import 'package:gymm/utils/snack_bar.dart';
import '../models/category.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int currentPage = 1;
  bool loading = false;
  bool productsLoading = false;
  String search = "";
  String _category = "All";
  bool hasMore = true;

  final List<Category> _categories = [];
  final List<Product> _products = [];
  CancelableOperation? _currentOperation;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.text = search;
    _loadCategories();
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _products.clear();
      currentPage = 1;
      hasMore = true;
    });
    await _loadMoreProducts();
  }

  Future<void> _loadCategories() async {
    if (loading) return;
    setState(() {
      loading = true;
    });

    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(getCategories());

    _currentOperation!.value.then((value) {
      if (!mounted) return;

      final List<Category> newCategories = value;
      setState(() {
        _categories.addAll(newCategories);
      });
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
        _loadMoreProducts();
      }
    });
  }

  void searchProducts() {
    setState(() {
      search = searchController.text.trim();
      currentPage = 1;
      hasMore = true;
      _products.clear();
      productsLoading = false;
    });
    _loadMoreProducts();
  }

  Future<void> _loadMoreProducts() async {
    if (productsLoading || !hasMore) return;
    setState(() {
      productsLoading = true;
    });

    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(
        getProducts(currentPage, search, _category.toLowerCase()));

    _currentOperation!.value.then((value) {
      if (!mounted) return;

      final (List<Product> newProducts, bool next) = value;
      setState(() {
        currentPage++;
        _products.addAll(newProducts);
        if (!next) {
          hasMore = false;
        }
      });
    }).catchError((e) {
      showSnackBar(context, "Failed loading products", "error");
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          productsLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshProducts,
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEndNotification) {
                  if (scrollEndNotification.metrics.extentAfter < 100) {
                    _loadMoreProducts();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 50, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_categories.isNotEmpty ||
                            (_products.isNotEmpty)) ...[
                          ProductsSearchBar(
                              searchController: searchController,
                              onSearch: searchProducts),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                        if (_categories.isNotEmpty) ...[
                          CategoriesTiles(
                            currentCategory: _category,
                            categoriesList: _categories,
                            onCategoryChanged: (category) {
                              setState(() {
                                _category = category;
                              });
                              searchProducts();
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          )
                        ],
                        ProductsList(productList: _products),
                        if (_products.isEmpty && !loading && !productsLoading)
                          const Center(
                            child: Text(
                              "No products found",
                              // "We will provide products soon,\nStay tuned!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        if (loading || productsLoading)
                          const Center(
                            child: Loading(
                              height: 100,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(bottom: 16, right: 16, child: ActionButtons()),
          ],
        ),
      ),
    );
  }
}
