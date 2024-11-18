import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Store.dart';
import 'package:gymm/providers/Cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
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
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/logo1.jpeg', height: 40),
          ),
        ],
      ),
      body: cart.cartProducts.isEmpty
          ? const EmptyCartView()
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartProducts.length,
              itemBuilder: (context, index) {
                return CartItemCard(product: cart.cartProducts[index]);
              },
            ),
          ),
          // تصميم السعر في الأعلى مباشرة تحت قائمة المنتجات
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Price:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  child: Text(
                    "${cart.calculateTotalPrice()} L.E",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedCartIcon(),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add items to your cart to see them here!',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 20),
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
            child: const Text('Continue Shopping',
                style: TextStyle(color: Colors.black)),
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

class _AnimatedCartIconState extends State<AnimatedCartIcon>
    with SingleTickerProviderStateMixin {
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
          offset: Offset(0, _controller.value * 30),
          child: Opacity(
            opacity: 0.5,
            child: Icon(
              Icons.shopping_cart,
              size: 80,
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

  const CartItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Container(
      color: Colors.transparent, // جعل الخلفية شفافة
      child: ListTile(
        contentPadding: const EdgeInsets.all(8), // padding داخلي قليل
        leading: Image.asset(product.image, width: 50, height: 50),
        title: Text(product.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text('${product.price} L.E',
            style: const TextStyle(color: Colors.white54)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrement Button
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.yellow),
              onPressed: () {
                cart.decrementProduct(product);
              },
            ),
            // Quantity Display
            Text('${product.quantity}',
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            // Increment Button
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () {
                cart.incrementProduct(product);
              },
            ),
            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cart.removeFromCart(product);
              },
            ),
          ],
        ),
      ),
    );
  }
}
