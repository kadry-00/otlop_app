import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/brand_model.dart';
import 'package:otlop_1/models/product_model.dart';
import 'package:otlop_1/models/restaurant_model.dart';
import 'package:otlop_1/screens/CartScreen.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_state.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_State.dart';
import 'package:otlop_1/widgets/ProductContainer.dart';
import 'package:otlop_1/widgets/w_cart_summary_bar.dart';
import 'package:otlop_1/widgets/smooth_page_route.dart';

class clsRestaurantDetailsScreen extends StatefulWidget {
  final BrandModel brand;
  final RestaurantModel? restaurant;
  final bool showCartBar;

  const clsRestaurantDetailsScreen({
    super.key,
    required this.brand,
    this.restaurant,
    this.showCartBar = false,
  });

  @override
  State<clsRestaurantDetailsScreen> createState() =>
      _clsRestaurantDetailsScreenState();
}

class _clsRestaurantDetailsScreenState
    extends State<clsRestaurantDetailsScreen> {
  late ProductsCubit _productsCubit;
  late RestaurantModel _restaurant;

  @override
  void initState() {
    super.initState();
    _restaurant = widget.restaurant ?? RestaurantModel.fromBrand(widget.brand);
    _productsCubit = ProductsCubit();
    _productsCubit.getProducts(brandId: widget.brand.id);
  }

  @override
  void dispose() {
    _productsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productsCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Collapsible App Bar with Cover
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: Appstyle.MainColor,
                  leading: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: const Color(0xFFFFECE8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Center(
                            child: Icon(
                              Icons.restaurant_rounded,
                              size: 72,
                              color: Appstyle.MainColor.withOpacity(0.3),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 20,
                            right: 20,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    _restaurant.name.isNotEmpty
                                        ? _restaurant.name[0].toUpperCase()
                                        : "R",
                                    style: const TextStyle(
                                      color: Appstyle.MainColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _restaurant.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _restaurant.categoryTag,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Restaurant Info Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoColumn(
                          Icons.star_rounded,
                          Colors.amber,
                          _restaurant.rating.toStringAsFixed(1),
                          "${_restaurant.ratingCount}+ ratings",
                        ),
                        _buildDivider(),
                        _buildInfoColumn(
                          Icons.timer_outlined,
                          Appstyle.MainColor,
                          _restaurant.deliveryTime,
                          "Delivery Time",
                        ),
                        _buildDivider(),
                        _buildInfoColumn(
                          Icons.delivery_dining_rounded,
                          Colors.green,
                          "${_restaurant.deliveryFee.toStringAsFixed(0)} EGP",
                          "Delivery Fee",
                        ),
                      ],
                    ),
                  ),
                ),
                // Menu Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      "Menu & Popular Items",
                      style: Appstyle.font18withbold.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                // Products List
                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    List<ProductModel> products = [];
                    bool isLoading = state is ProductsLoadingState;
                    String? error;

                    if (state is ProductsSuccessState) {
                      products = state.products;
                    } else if (state is ProductsFailureState) {
                      error = state.erro;
                    }

                    if (isLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Appstyle.MainColor),
                          ),
                        ),
                      );
                    }

                    if (error != null) {
                      return SliverFillRemaining(
                        child: Center(child: Text("Error: $error")),
                      );
                    }

                    if (products.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text("No items available in this restaurant"),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 250,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return clsProductCard(product: products[index]);
                          },
                          childCount: products.length,
                        ),
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            // Floating Bottom Cart Bar (Restaurant Details - Cart)
            BlocBuilder<BasketCubit, BasketState>(
              builder: (context, state) {
                final basket =
                    context.read<BasketCubit>().currentBasket;
                final count = basket?.totalCount ?? 0;
                final total = basket?.totalPrice ?? 0.0;

                if (count <= 0) return const SizedBox.shrink();

                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: CartSummaryBarWidget(
                      itemCount: count,
                      totalPrice: total,
                      onViewCart: () {
                        navigateSmoothly(context, const clsCartScreen());
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
      IconData icon, Color color, String topText, String bottomText) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              topText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          bottomText,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 1,
      color: const Color(0xFFEEEEEE),
    );
  }
}
