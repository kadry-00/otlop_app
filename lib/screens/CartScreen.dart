import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/address_model.dart';
import 'package:otlop_1/models/basket_model.dart';
import 'package:otlop_1/models/order_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_state.dart';
import 'package:otlop_1/screens/Cubit/cubit_orders/orders_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_profile/profile_cubit.dart';
import 'package:otlop_1/screens/MainNavigationScreen.dart';
import 'package:otlop_1/widgets/CartProuductShow.dart';
import 'package:otlop_1/widgets/HeadertitleAndCount.dart';
import 'package:otlop_1/widgets/w_address_dialog.dart';
import 'package:otlop_1/widgets/smooth_page_route.dart';

class clsCartScreen extends StatefulWidget {
  const clsCartScreen({super.key});

  @override
  State<clsCartScreen> createState() => _clsCartScreenState();
}

class _clsCartScreenState extends State<clsCartScreen> {
  DeliveryMethodModel? _selectedDeliveryMethod;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    context.read<BasketCubit>().fetchBasket();
    context.read<OrdersCubit>().fetchDeliveryMethods();
    context.read<ProfileCubit>().loadProfile();
  }

  void _showAddressDialog(AddressModel? currentAddress) {
    showDialog(
      context: context,
      builder: (context) => AddressDialogWidget(
        initialAddress: currentAddress,
        onSave: (newAddress) {
          context.read<ProfileCubit>().updateAddress(newAddress);
        },
      ),
    );
  }

  Future<void> _placeOrder(CustomerBasketModel basket, AddressModel? address) async {
    if (address == null) {
      _showAddressDialog(null);
      return;
    }

    final ordersCubit = context.read<OrdersCubit>();
    final basketCubit = context.read<BasketCubit>();
    final deliveryMethods = ordersCubit.deliveryMethods;
    final methodId = _selectedDeliveryMethod?.id ?? (deliveryMethods.isNotEmpty ? deliveryMethods.first.id : 1);

    setState(() => _isPlacingOrder = true);
    try {
      await ordersCubit.createOrder(
            deliveryMethodId: methodId,
            shippingAddress: address,
          );
      await basketCubit.clearBasket();

      if (!mounted) return;
      setState(() => _isPlacingOrder = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order placed successfully! 🎉"),
          backgroundColor: Colors.green,
        ),
      );

      navigateSmoothly(
        context,
        const MainNavigationScreen(initialIndex: 3),
        clearStack: true,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPlacingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not place order: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocBuilder<BasketCubit, BasketState>(
        builder: (context, state) {
          CustomerBasketModel basket =
              context.read<BasketCubit>().currentBasket ?? CustomerBasketModel(items: []);
          bool isLoading = state is BasketLoadingState;
          String? errorMessage;

          if (state is BasketSuccessState) {
            basket = state.basket;
          } else if (state is BasketFailureState) {
            errorMessage = state.error;
          }

          final deliveryMethods = context.watch<OrdersCubit>().deliveryMethods;
          if (_selectedDeliveryMethod == null && deliveryMethods.isNotEmpty) {
            _selectedDeliveryMethod = deliveryMethods.first;
          }

          final deliveryCost = _selectedDeliveryMethod?.cost ?? 15.0;
          final finalTotal = basket.totalPrice + (basket.items.isNotEmpty ? deliveryCost : 0.0);
          final currentAddress = context.watch<ProfileCubit>().currentAddress;

          return Column(
            children: [
              wHeadertiltleAndCount(
                screenTiltle: "Your Cart",
                countItem: basket.totalCount,
              ),
              if (isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Appstyle.MainColor),
                ),
              Expanded(
                child: errorMessage != null && basket.items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                              const SizedBox(height: 12),
                              Text(errorMessage, textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Appstyle.MainColor),
                                onPressed: () => context.read<BasketCubit>().fetchBasket(),
                                child: const Text("Retry", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : basket.items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_bag_outlined,
                                    size: 72, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  "Your cart is empty",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Explore and add your favorite meals",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              // Cart Items List
                              ...basket.items.map(
                                (item) => clsProuductCart(
                                  item: item,
                                  onIncrement: () async {
                                    try {
                                      await context.read<BasketCubit>().addToBasket(
                                            productId: item.id,
                                            quantity: 1,
                                          );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  },
                                  onDecrement: () async {
                                    try {
                                      await context.read<BasketCubit>().addToBasket(
                                            productId: item.id,
                                            quantity: -1,
                                          );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Delivery Address Card
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFF0F0F0)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Appstyle.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        color: Appstyle.MainColor,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Deliver to",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            currentAddress != null
                                                ? currentAddress.fullAddress
                                                : "Tap to set your address",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _showAddressDialog(currentAddress),
                                      child: const Text(
                                        "Change",
                                        style: TextStyle(
                                          color: Appstyle.MainColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Delivery Method Selector
                              if (deliveryMethods.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFF0F0F0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Delivery Option",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...deliveryMethods.map((method) {
                                        final isSelected =
                                            _selectedDeliveryMethod?.id == method.id;
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedDeliveryMethod = method;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isSelected
                                                      ? Icons.radio_button_checked
                                                      : Icons.radio_button_off,
                                                  color: isSelected
                                                      ? Appstyle.MainColor
                                                      : Colors.grey,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    "${method.shortName} (${method.deliveryTime})",
                                                    style: const TextStyle(fontSize: 13),
                                                  ),
                                                ),
                                                Text(
                                                  "${method.cost.toStringAsFixed(0)} EGP",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 24),
                            ],
                          ),
              ),
              if (basket.items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            Text(
                              "${basket.totalPrice.toStringAsFixed(0)} EGP",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Delivery Fee",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            Text(
                              "${deliveryCost.toStringAsFixed(0)} EGP",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "${finalTotal.toStringAsFixed(0)} EGP",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Appstyle.MainColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appstyle.MainColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _isPlacingOrder
                                ? null
                                : () => _placeOrder(basket, currentAddress),
                            child: _isPlacingOrder
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    "Place Order",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
