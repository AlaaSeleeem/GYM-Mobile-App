import 'package:flutter/material.dart';

import 'Store.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // لون الخلفية الأسود
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Product', // عنوان الصفحة
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            Image.asset(
              'assets/logo1.jpeg', // تأكد من مسار الشعار
              height: 40,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج تأخذ عرض الصفحة كامل وارتفاع الشاشة
            Center(
              child: Container(
                width: double.infinity, // عرض الصورة كامل
                height: MediaQuery.of(context).size.height * 0.5, // ارتفاع الصورة
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover, // ملائمة الصورة
                ),
              ),
            ),
            SizedBox(height: 16),
            // اسم المنتج
            Text(
              product.name, // استخدام اسم المنتج من الكائن
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow, // لون الاسم
              ),
            ),
            SizedBox(height: 8),
            // سعر المنتج
            Row(
              children: [
                if (product.discount != null) ...[
                  Text(
                    '${product.price} L.E',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
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
            SizedBox(height: 8),
            // وصف المنتج
            Text(
              product.description,
              style: TextStyle(color: Colors.white54),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            // زر إضافة إلى السلة
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} has been added to the cart'), // استخدام اسم المنتج هنا أيضًا
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text('Add to Cart', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
