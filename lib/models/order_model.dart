import 'package:otlop_1/models/address_model.dart';

class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final String pictureUrl;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.pictureUrl,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int? ?? 0,
      productId: json['productId'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'pictureUrl': pictureUrl,
      'quantity': quantity,
      'price': price,
    };
  }
}

class DeliveryMethodModel {
  final int id;
  final String shortName;
  final String description;
  final double cost;
  final String deliveryTime;

  DeliveryMethodModel({
    required this.id,
    required this.shortName,
    required this.description,
    required this.cost,
    required this.deliveryTime,
  });

  factory DeliveryMethodModel.fromJson(Map<String, dynamic> json) {
    return DeliveryMethodModel(
      id: json['id'] as int? ?? 0,
      shortName: json['shortName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      deliveryTime: json['deliveryTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortName': shortName,
      'description': description,
      'cost': cost,
      'deliveryTime': deliveryTime,
    };
  }
}

class OrderModel {
  final int id;
  final String buyerEmail;
  final AddressModel? shippingAddress;
  final String status;
  final String orderDate;
  final List<OrderItemModel> items;
  final String deliveryMethod;
  final double deliveryCost;
  final double subTotal;
  final double total;
  final String? paymentIntentId;

  OrderModel({
    required this.id,
    required this.buyerEmail,
    this.shippingAddress,
    required this.status,
    required this.orderDate,
    required this.items,
    required this.deliveryMethod,
    required this.deliveryCost,
    required this.subTotal,
    required this.total,
    this.paymentIntentId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List? ?? [];
    List<OrderItemModel> orderItems = rawItems
        .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return OrderModel(
      id: json['id'] as int? ?? 0,
      buyerEmail: json['buyerEmail'] as String? ?? '',
      shippingAddress: json['shippingAddress'] != null
          ? AddressModel.fromJson(
              json['shippingAddress'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String? ?? 'Pending',
      orderDate: json['orderDate'] as String? ?? '',
      items: orderItems,
      deliveryMethod: json['deliveryMethod'] as String? ?? '',
      deliveryCost: (json['deliveryCost'] as num?)?.toDouble() ?? 0.0,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      paymentIntentId: json['paymentIntentId'] as String?,
    );
  }
}
