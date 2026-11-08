class CategoryModel {
  final int id;
  final String name;
  final String? pictureUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.pictureUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pictureUrl': pictureUrl,
    };
  }
}
