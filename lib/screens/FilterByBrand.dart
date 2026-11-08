import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/models/brand_model.dart';
import 'package:otlop_1/models/product_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_State.dart';
import 'package:otlop_1/widgets/FilterHeader.dart';
import 'package:otlop_1/widgets/FilterList.dart';

class clsFilterByBrand extends StatefulWidget {
  final BrandModel brand;

  const clsFilterByBrand({
    super.key,
    required this.brand,
  });

  @override
  State<clsFilterByBrand> createState() => _clsFilterByBrandState();
}

class _clsFilterByBrandState extends State<clsFilterByBrand> {
  final TextEditingController _searchController = TextEditingController();
  late ProductsCubit _productsCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = ProductsCubit();
    _productsCubit.getProducts(brandId: widget.brand.id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productsCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                List<ProductModel> products = [];
                bool isLoading = state is ProductsLoadingState;
                String? error;
                int count = 0;

                if (state is ProductsSuccessState) {
                  products = state.products;
                  count = state.totalCount > 0 ? state.totalCount : products.length;
                } else if (state is ProductsFailureState) {
                  error = state.erro;
                }

                return Column(
                  children: [
                    clsFilterHeader(
                      title: widget.brand.name,
                      itemsCount: count,
                      searchController: _searchController,
                      onSearchChanged: (query) {
                        _productsCubit.getProducts(
                          brandId: widget.brand.id,
                          search: query,
                        );
                      },
                    ),
                    Expanded(
                      child: clsFilterList(
                        products: products,
                        isLoading: isLoading,
                        errorMessage: error,
                        onRetry: () {
                          _productsCubit.getProducts(
                            brandId: widget.brand.id,
                            search: _searchController.text,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
