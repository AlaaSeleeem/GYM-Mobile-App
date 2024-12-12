class Product {
  final int id;
  final String name;
  final String? description;
  final String category;
  final double sellPrice;
  final double costPrice;
  final double? discount;
  final int stock;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.sellPrice,
    required this.costPrice,
    this.discount,
    required this.stock,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      sellPrice: double.parse(json['sell_price']),
      costPrice: double.parse(json['cost_price']),
      discount: json["discount"] != null
          ? double.parse(json['discount'].toString())
          : null,
      stock: json['stock'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'sell_price': sellPrice,
      'cost_price': costPrice,
      'discount': discount,
      'stock': stock,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
