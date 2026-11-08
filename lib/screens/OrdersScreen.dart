import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/screens/Cubit/cubit_orders/orders_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_orders/orders_state.dart';
import 'package:otlop_1/widgets/w_order_card.dart';

class clsOrdersScreen extends StatefulWidget {
  const clsOrdersScreen({super.key});

  @override
  State<clsOrdersScreen> createState() => _clsOrdersScreenState();
}

class _clsOrdersScreenState extends State<clsOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().fetchOrders();
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
                "My Orders",
                style: Appstyle.font18withbold.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                "Track current and past deliveries",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Appstyle.MainColor),
                        ),
                      );
                    } else if (state is OrdersFailureState) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.redAccent),
                            const SizedBox(height: 12),
                            Text(
                              state.error,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Appstyle.MainColor),
                              onPressed: () =>
                                  context.read<OrdersCubit>().fetchOrders(),
                              child: const Text("Retry",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    } else if (state is OrdersSuccessState) {
                      final orders = state.orders;
                      if (orders.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 14),
                              Text(
                                "No orders yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Your order history will appear right here",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return OrderCardWidget(
                            order: order,
                            onReorder: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Reordering items from Order #${order.id}..."),
                                  backgroundColor: Colors.green,
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
