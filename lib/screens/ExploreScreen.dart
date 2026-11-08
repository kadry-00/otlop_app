import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/category_model.dart';
import 'package:otlop_1/models/product_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Categoris_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Categoris_State.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_State.dart';
import 'package:otlop_1/widgets/FilterList.dart';
import 'package:otlop_1/widgets/searchfilter.dart';

class clsExploreScreen extends StatefulWidget {
  const clsExploreScreen({super.key});

  @override
  State<clsExploreScreen> createState() => _clsExploreScreenState();
}

class _clsExploreScreenState extends State<clsExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().getProducts();
    context.read<CategorisCubit>().getCategoris();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explore Food & Drinks",
                style: Appstyle.font18withbold.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 14),
              clsSearchFilter(
                hText: "Search dishes, restaurants...",
                controller: _searchController,
                onChanged: (val) {
                  context.read<ProductsCubit>().getProducts(
                        categoryId: _selectedCategoryId,
                        search: val,
                      );
                },
                onFilterTap: () {
                  setState(() {
                    _selectedCategoryId = null;
                    _searchController.clear();
                  });
                  context.read<ProductsCubit>().getProducts();
                },
              ),
              const SizedBox(height: 14),
              // Category Filter Pills
              SizedBox(
                height: 38,
                child: BlocBuilder<CategorisCubit, CategorisState>(
                  builder: (context, state) {
                    if (state is CategorisSuccessState) {
                      final categories = [
                        CategoryModel(id: -1, name: "All"),
                        ...state.categoris,
                      ];
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = cat.id == -1
                              ? _selectedCategoryId == null
                              : _selectedCategoryId == cat.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryId =
                                    cat.id == -1 ? null : cat.id;
                              });
                              context.read<ProductsCubit>().getProducts(
                                    categoryId: _selectedCategoryId,
                                    search: _searchController.text,
                                  );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Appstyle.MainColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Appstyle.MainColor
                                      : const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Products Count & Grid
              Expanded(
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    List<ProductModel> products = [];
                    bool isLoading = state is ProductsLoadingState;
                    String? error;

                    if (state is ProductsSuccessState) {
                      products = state.products;
                    } else if (state is ProductsFailureState) {
                      error = state.erro;
                    }

                    return clsFilterList(
                      products: products,
                      isLoading: isLoading,
                      errorMessage: error,
                      onRetry: () {
                        context.read<ProductsCubit>().getProducts(
                              categoryId: _selectedCategoryId,
                              search: _searchController.text,
                            );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
