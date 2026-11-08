import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/screens/CartScreen.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_state.dart';
import 'package:otlop_1/screens/ExploreScreen.dart';
import 'package:otlop_1/screens/HomeScreen.dart';
import 'package:otlop_1/screens/OrdersScreen.dart';
import 'package:otlop_1/screens/ProfileScreen.dart';
import 'package:otlop_1/screens/auth/LoginScreesn.dart';
import 'package:otlop_1/widgets/w_bottom_navigation.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _screens =  [
    clsHomeScreen(),
    clsExploreScreen(),
    clsCartScreen(),
    clsOrdersScreen(),
    clsProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthSession.isLoggedIn) {
      return const clsLoginScreen();
    }

    return BlocBuilder<BasketCubit, BasketState>(
      builder: (context, state) {
        final cartCount =
            context.read<BasketCubit>().currentBasket?.totalCount ?? 0;

        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _screens,
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: _currentIndex,
            cartCount: cartCount,
            onTap: _onTabTapped,
          ),
        );
      },
    );
  }
}
