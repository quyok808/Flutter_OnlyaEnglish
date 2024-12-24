class Product {
  final int? id;
  final String name;
  final double price;
  final String description;

  Product(
      {this.id,
      required this.name,
      required this.price,
      required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'price': price,
    };
    if (description != null) {
      data['description'] = description;
    }
    if (id != null) {
      data['id'] = id as int; // id có thể gửi khi cần
    }
    return data;
  }
}
