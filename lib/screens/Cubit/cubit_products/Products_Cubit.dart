import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/Home_remote_api.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_State.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsLoadingState());
  final HomeRemoteApi homeremoteApi = HomeRemoteApi();

  int? _currentCategoryId;
  int? _currentBrandId;
  String? _currentSearch;
  String? _currentSort;

  int? get currentCategoryId => _currentCategoryId;
  int? get currentBrandId => _currentBrandId;
  String? get currentSearch => _currentSearch;

  Future<void> getProducts({
    int? categoryId,
    int? brandId,
    String? search,
    String? sort,
  }) async {
    _currentCategoryId = categoryId;
    _currentBrandId = brandId;
    _currentSearch = search;
    _currentSort = sort;

    emit(ProductsLoadingState());
    try {
      final res = await homeremoteApi.getProducts(
        categoryId: _currentCategoryId,
        brandId: _currentBrandId,
        search: _currentSearch,
        sort: _currentSort,
        pageSize: 50,
      );

      emit(ProductsSuccessState(
        products: res.data,
        totalCount: res.count,
        activeSearch: _currentSearch,
        activeBrandId: _currentBrandId,
        activeCategoryId: _currentCategoryId,
      ));
    } catch (e) {
      emit(ProductsFailureState(erro: e.toString()));
    }
  }

  void searchProducts(String query) {
    getProducts(
      categoryId: _currentCategoryId,
      brandId: _currentBrandId,
      search: query,
      sort: _currentSort,
    );
  }

  void filterByCategory(int? categoryId) {
    getProducts(
      categoryId: categoryId,
      brandId: _currentBrandId,
      search: _currentSearch,
      sort: _currentSort,
    );
  }

  void filterByBrand(int? brandId) {
    getProducts(
      categoryId: _currentCategoryId,
      brandId: brandId,
      search: _currentSearch,
      sort: _currentSort,
    );
  }

  void resetFilters() {
    getProducts();
  }
}
