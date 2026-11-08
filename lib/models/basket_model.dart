class BasketItemModel {
  final int id;
  final String productName;
  final double price;
  final String pictureUrl;
  final String category;
  final String brand;
  int quantity;

  BasketItemModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.pictureUrl,
    required this.category,
    required this.brand,
    required this.quantity,
  });

  factory BasketItemModel.fromJson(Map<String, dynamic> json) {
    return BasketItemModel(
      id: json['id'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      pictureUrl: json['pictureUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'price': price,
      'pictureUrl': pictureUrl,
      'category': category,
      'brand': brand,
      'quantity': quantity,
    };
  }
}

class CustomerBasketModel {
  final String? id;
  final List<BasketItemModel> items;

  CustomerBasketModel({this.id, required this.items});

  factory CustomerBasketModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List? ?? [];
    List<BasketItemModel> list = rawItems
        .map((e) => BasketItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return CustomerBasketModel(
      id: json['id'] as String?,
      items: list,
    );
  }

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
