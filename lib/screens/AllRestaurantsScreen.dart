import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/restaurant_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Brands_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Brands_State.dart';
import 'package:otlop_1/screens/RestaurantDetailsScreen.dart';
import 'package:otlop_1/widgets/searchfilter.dart';
import 'package:otlop_1/widgets/w_restaurant_card.dart';
import 'package:otlop_1/widgets/smooth_page_route.dart';

class clsAllRestaurantsScreen extends StatefulWidget {
  const clsAllRestaurantsScreen({super.key});

  @override
  State<clsAllRestaurantsScreen> createState() => _clsAllRestaurantsScreenState();
}

class _clsAllRestaurantsScreenState extends State<clsAllRestaurantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<BrandsCubit>().getBrands();
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFF0F0F0),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    "All Restaurants",
                    style: Appstyle.font18withbold.copyWith(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              clsSearchFilter(
                hText: "Search restaurants by name...",
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _filterQuery = val.trim().toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<BrandsCubit, BrandsState>(
                  builder: (context, state) {
                    if (state is BrandsLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Appstyle.MainColor),
                        ),
                      );
                    } else if (state is BrandsFailureState) {
                      return Center(child: Text("Error: ${state.erro}"));
                    } else if (state is BrandsSuccessState) {
                      final brands = state.brands;
                      final filtered = brands.where((b) {
                        if (_filterQuery.isEmpty) return true;
                        return b.name.toLowerCase().contains(_filterQuery);
                      }).toList();

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text("No restaurants match your search"),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final brand = filtered[index];
                          final restaurant = RestaurantModel.fromBrand(brand);
                          return RestaurantCardWidget(
                            restaurant: restaurant,
                            onTap: () {
                              navigateSmoothly(
                                context,
                                clsRestaurantDetailsScreen(
                                  brand: brand,
                                  restaurant: restaurant,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
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
