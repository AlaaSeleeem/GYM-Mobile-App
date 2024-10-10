import 'package:flutter/material.dart';

import 'Store.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartProducts;

  CartPage({required this.cartProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, color: Colors.yellow),
            SizedBox(width: 8),
            Text(
              'Cart',
              style: TextStyle(color: Colors.yellow, fontSize: 20),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('logo1.jpeg', height: 40),
          ),
        ],
      ),
      body: cartProducts.isEmpty
          ? EmptyCartView()
          : ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          return CartItemCard(product: cartProducts[index]);
        },
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedCartIcon(), // الأيقونة الكبيرة مع الحركة
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            'Add items to your cart to see them here!',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: Text('Continue Shopping', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class AnimatedCartIcon extends StatefulWidget {
  @override
  _AnimatedCartIconState createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 30), // الحركة لأعلى ولأسفل
          child: Opacity(
            opacity: 0.5, // التلاشي
            child: Icon(
              Icons.shopping_cart,
              size: 80, // حجم الأيقونة
              color: Colors.yellow,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CartItemCard extends StatelessWidget {
  final Product product;

  CartItemCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.grey[800],
      child: ListTile(
        leading: Image.asset(product.image, width: 50, height: 50),
        title: Text(product.name, style: TextStyle(color: Colors.white)),
        subtitle: Text('${product.price} L.E', style: TextStyle(color: Colors.white54)),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () {
            // وظيفة حذف المنتج
          },
        ),
      ),
    );
  }
}

// نموذج المنتج
class Product {
  final String name;
  final double price;
  final String image;

  Product({required this.name, required this.price, required this.image});
}