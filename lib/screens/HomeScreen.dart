import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/models/product_model.dart';
import 'package:otlop_1/screens/AllRestaurantsScreen.dart';
import 'package:otlop_1/screens/CartScreen.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_state.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Brands_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Brands_State.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Categoris_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Categoris_State.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_State.dart';
import 'package:otlop_1/screens/FilterByCategory.dart';
import 'package:otlop_1/screens/RestaurantDetailsScreen.dart';
import 'package:otlop_1/widgets/FilterList.dart';
import 'package:otlop_1/widgets/FilterRow.dart';
import 'package:otlop_1/widgets/brand_chip.dart';
import 'package:otlop_1/widgets/catgoryItem.dart';
import 'package:otlop_1/widgets/searchfilter.dart';
import 'package:otlop_1/widgets/w_hero_banner.dart';
import 'package:otlop_1/widgets/smooth_page_route.dart';

class clsHomeScreen extends StatefulWidget {
  final String? userName;
  clsHomeScreen({super.key,  this.userName});

  @override
  State<clsHomeScreen> createState() => _clsHomeScreenState();
}

class _clsHomeScreenState extends State<clsHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;
  int? _selectedBrandId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().getProducts();
      context.read<CategorisCubit>().getCategoris();
      context.read<BrandsCubit>().getBrands();
      context.read<BasketCubit>().fetchBasket();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      if (_selectedCategoryId == categoryId) {
        _selectedCategoryId = null;
      } else {
        _selectedCategoryId = categoryId;
      }
    });

    context.read<ProductsCubit>().getProducts(
      categoryId: _selectedCategoryId,
      brandId: _selectedBrandId,
      search: _searchController.text,
    );
  }

  void _onBrandSelected(int brandId) {
    setState(() {
      if (_selectedBrandId == brandId) {
        _selectedBrandId = null;
      } else {
        _selectedBrandId = brandId;
      }
    });

    context.read<ProductsCubit>().getProducts(
      categoryId: _selectedCategoryId,
      brandId: _selectedBrandId,
      search: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = AuthSession.displayName ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Good day", style: Appstyle.font14withSemiBold),
                          const SizedBox(width: 4),
                          const Text("👋", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userName,
                        style: Appstyle.Font25pxwithSemiBoldweight.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Cart button with badge
                  BlocBuilder<BasketCubit, BasketState>(
                    builder: (context, state) {
                      final count =
                          context
                              .read<BasketCubit>()
                              .currentBasket
                              ?.totalCount ??
                          0;
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                navigateSmoothly(
                                  context,
                                  const clsCartScreen(),
                                );
                              },
                              icon: const Icon(Icons.shopping_bag_outlined),
                              color: Appstyle.MainColor,
                            ),
                          ),
                          if (count > 0)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Appstyle.MainColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  // Notification icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Location chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Appstyle.secondary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Appstyle.MainColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Cairo, Egypt",
                      style: Appstyle.font14withSemiBold.copyWith(
                        color: Appstyle.MainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Search bar with filter
              clsSearchFilter(
                hText: "Search products, meals, drinks...",
                controller: _searchController,
                onChanged: (query) {
                  context.read<ProductsCubit>().getProducts(
                    categoryId: _selectedCategoryId,
                    brandId: _selectedBrandId,
                    search: query,
                  );
                },
                onFilterTap: () {
                  setState(() {
                    _selectedCategoryId = null;
                    _selectedBrandId = null;
                    _searchController.clear();
                  });
                  context.read<ProductsCubit>().getProducts();
                },
              ),

              const SizedBox(height: 12),

              // Top Content (Scrollable or Collapsible headers)
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hero Banner (Figma Screen 3 Hero Banner)
                            const HeroBannerWidget(),
                            const SizedBox(height: 16),

                            // Categories Section
                            clsFilterRow(
                              Title: "Categories",
                              supTitle: "See all",
                              onSeeAllTap: () {},
                            ),
                            SizedBox(
                              height: 105,
                              child:
                                  BlocBuilder<CategorisCubit, CategorisState>(
                                    builder: (context, state) {
                                      if (state is CategorisLoadingState) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Appstyle.MainColor,
                                                ),
                                          ),
                                        );
                                      } else if (state
                                          is CategorisSuccessState) {
                                        final categories = state.categoris;
                                        return ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: categories.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(width: 14),
                                          itemBuilder: (context, index) {
                                            final cat = categories[index];
                                            final isSelected =
                                                _selectedCategoryId == cat.id;

                                            return GestureDetector(
                                              onLongPress: () {
                                                navigateSmoothly(
                                                  context,
                                                  clsFilterByCategory(
                                                    category: cat,
                                                  ),
                                                );
                                              },
                                              child: clsCategoryItem(
                                                category: cat,
                                                isSelected: isSelected,
                                                onTap: () =>
                                                    _onCategorySelected(cat.id),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                            ),

                            const SizedBox(height: 8),

                            // Brands / Restaurants Section
                            clsFilterRow(
                              Title: "Top Restaurants & Brands",
                              supTitle: "View all",
                              onSeeAllTap: () {
                                navigateSmoothly(
                                  context,
                                  const clsAllRestaurantsScreen(),
                                );
                              },
                            ),
                            SizedBox(
                              height: 42,
                              child: BlocBuilder<BrandsCubit, BrandsState>(
                                builder: (context, state) {
                                  if (state is BrandsSuccessState) {
                                    final brands = state.brands;
                                    return ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: brands.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 10),
                                      itemBuilder: (context, index) {
                                        final brand = brands[index];
                                        final isSelected =
                                            _selectedBrandId == brand.id;

                                        return GestureDetector(
                                          onLongPress: () {
                                            navigateSmoothly(
                                              context,
                                              clsRestaurantDetailsScreen(
                                                brand: brand,
                                              ),
                                            );
                                          },
                                          child: clsBrandChip(
                                            brand: brand,
                                            isSelected: isSelected,
                                            onTap: () =>
                                                _onBrandSelected(brand.id),
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

                            // Section Title
                            clsFilterRow(
                              Title: "Popular Dishes",
                              supTitle:
                                  _selectedCategoryId != null ||
                                      _selectedBrandId != null
                                  ? "Reset filters"
                                  : "",
                              onSeeAllTap: () {
                                setState(() {
                                  _selectedCategoryId = null;
                                  _selectedBrandId = null;
                                  _searchController.clear();
                                });
                                context.read<ProductsCubit>().getProducts();
                              },
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: BlocBuilder<ProductsCubit, ProductsState>(
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
                            brandId: _selectedBrandId,
                            search: _searchController.text,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
