import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gymm/productDetail.dart';
import 'package:gymm/providers/Cart.dart';
import 'dart:async';
import 'FINALbuttonNAVbar.dart';
import 'cartPage.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  String _searchQuery = '';

  final List<String> offers = [
    'offer1.jfif',
    'offer2.jfif',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % offers.length;
        _pageController.jumpToPage(_currentPage);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
          id: 1,
          name:
          ' product 1',
          price: 100,
          image: 'product1.jpg',
          description:
          'Short description for product 1Short description for product 1 Short description for product 1Short description for',
          discount: 20),
      Product(
          id: 2,
          name: 'Product 2',
          price: 150,
          image: 'product1.jpg',
          description: 'Short description for product 2 '),
      Product(
          id: 3,
          name: 'Product 3',
          price: 200,
          image: 'product1.jpg',
          description: 'Short description for product 3',
          discount: 30),
      Product(
          id: 4,
          name: 'Product 4',
          price: 120,
          image: 'product1.jpg',
          description: 'Short description for product 4'),
      Product(
          id: 5,
          name: 'Product 5',
          price: 180,
          image: 'product1.jpg',
          description: 'Short description for product 5',
          discount: 15),
      Product(
          id: 6,
          name: 'Product 6',
          price: 250,
          image: 'product1.jpg',
          description: 'Short description for product 6'),
    ];

    // فلترة المنتجات بناءً على نص البحث
    List<Product> filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.yellow),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Products',
                style: TextStyle(color: Colors.yellow, fontSize: 20),
              ),
              SizedBox(width: 80),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search here...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        // إضافة وظيفة للبحث هنا
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Image.asset('logo1.jpeg', height: 40),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    initialPage: _currentPage,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  items: offers.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: filteredProducts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ZoomableProductCard(
                      product: filteredProducts[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          },
          backgroundColor: Colors.yellow,
          child: Icon(Icons.shopping_cart, color: Colors.black),
        ),
        bottomNavigationBar: BottonNavBar(),
      ),
    );
  }
}


class AnimatedDialog extends StatefulWidget {
  final String productName;

  AnimatedDialog({required this.productName});

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(Icons.check_circle, color: Colors.yellow, size: 40),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Product Added',
              style: TextStyle(color: Colors.yellow),
            ),
          ],
        ),
        content: Text(
          '${widget.productName} has been added to your cart.',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ZoomableProductCard extends StatefulWidget {
  final Product product;

  // final Function(String) onAddToCart;

  const ZoomableProductCard({super.key, required this.product});

  @override
  _ZoomableProductCardState createState() => _ZoomableProductCardState();
}

class _ZoomableProductCardState extends State<ZoomableProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: widget.product),
            ),
          );
        },
        child: Transform.scale(
          scale: 1, //_isHovered ? 1.1 : 1.0,
          child: Container(
            child: ProductCard(
              product: widget.product,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    void _showAddToCartDialog(String productName) {
      showDialog(
        context: context,
        builder: (context) {
          return AnimatedDialog(productName: productName);
        },
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis, // تحديد حد أقصى لوصف المنتج
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (product.discount != null) ...[
                        Text(
                          '${product.price} L.E',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.yellow,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${product.price - product.discount!} L.E',
                          style: TextStyle(fontSize: 20, color: Colors.yellow),
                        ),
                      ] else ...[
                        Text(
                          '${product.price} L.E',
                          style: TextStyle(fontSize: 20, color: Colors.yellow),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.white54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // تطبيق ellipsis
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _showAddToCartDialog(product.name);
                cart.addToCart(product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_shopping_cart, color: Colors.black),
                  SizedBox(width: 4),
                  Text('Add to Cart', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
        if (product.discount != null)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    '${((product.discount! / product.price) * 100).round()}%',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'OFF',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Product model
class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final double? discount;
  int quantity = 1;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.image,
      required this.description,
      this.discount});
}


