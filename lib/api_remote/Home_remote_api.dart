import 'package:dio/dio.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/api_remote/api_error_handler.dart';
import 'package:otlop_1/models/brand_model.dart';
import 'package:otlop_1/models/category_model.dart';
import 'package:otlop_1/models/product_model.dart';

class HomeRemoteApi {
  final Dio dio = ApiClient.dio;

  Future<ProductPaginationModel> getProducts({
    int? categoryId,
    int? brandId,
    String? search,
    String? sort,
    int pageIndex = 1,
    int pageSize = 20,
  }) async {
    try {
      final Map<String, dynamic> query = {
        'PageIndex': pageIndex,
        'PageSize': pageSize,
      };

      if (categoryId != null && categoryId > 0) {
        query['categoryId'] = categoryId;
      }
      if (brandId != null && brandId > 0) {
        query['brandId'] = brandId;
      }
      if (search != null && search.trim().isNotEmpty) {
        query['Search'] = search.trim();
      }
      if (sort != null && sort.trim().isNotEmpty) {
        query['sort'] = sort.trim();
      }

      final response = await dio.get(
        "/api/Products",
        queryParameters: query,
      );

      return ProductPaginationModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get("/api/Products/$id");
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get("/api/Products/categories");
      final list = (response.data as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await dio.get("/api/Products/brands");
      final list = (response.data as List)
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

// Backward compatibility alias if needed
typedef clsHomeremoteApi = HomeRemoteApi;
