class ProductModel {
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final double price;
  final int brandId;
  final String brand;
  final int categoryId;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.price,
    required this.brandId,
    required this.brand,
    required this.categoryId,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      brandId: json['brandId'] as int? ?? 0,
      brand: json['brand'] as String? ?? '',
      categoryId: json['categoryId'] as int? ?? 0,
      category: json['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureUrl': pictureUrl,
      'price': price,
      'brandId': brandId,
      'brand': brand,
      'categoryId': categoryId,
      'category': category,
    };
  }
}

class ProductPaginationModel {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<ProductModel> data;

  ProductPaginationModel({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.data,
  });

  factory ProductPaginationModel.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'] as List? ?? [];
    List<ProductModel> products = rawList
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductPaginationModel(
      pageIndex: json['page_Index'] as int? ?? json['pageIndex'] as int? ?? 1,
      pageSize: json['page_Size'] as int? ?? json['pageSize'] as int? ?? 10,
      count: json['count'] as int? ?? products.length,
      data: products,
    );
  }
}
