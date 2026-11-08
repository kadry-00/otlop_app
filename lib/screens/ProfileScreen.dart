import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/models/address_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_profile/profile_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_profile/profile_state.dart';
import 'package:otlop_1/screens/OrdersScreen.dart';
import 'package:otlop_1/screens/auth/LoginScreesn.dart';
import 'package:otlop_1/widgets/w_address_dialog.dart';
import 'package:otlop_1/widgets/w_profile_menu_item.dart';
import 'package:otlop_1/widgets/smooth_page_route.dart';

class clsProfileScreen extends StatefulWidget {
  const clsProfileScreen({super.key});

  @override
  State<clsProfileScreen> createState() => _clsProfileScreenState();
}

class _clsProfileScreenState extends State<clsProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  void _showEditAddress(AddressModel? currentAddress) {
    showDialog(
      context: context,
      builder: (context) => AddressDialogWidget(
        initialAddress: currentAddress,
        onSave: (newAddress) {
          context.read<ProfileCubit>().updateAddress(newAddress);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Address updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final userName = AuthSession.displayName ?? "User";
            final userEmail = AuthSession.email ?? "user@example.com";
            AddressModel? address;

            if (state is ProfileSuccessState) {
              address = state.address;
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: Appstyle.font18withbold.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  // User Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Appstyle.secondary,
                          child: Text(
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : "U",
                            style: const TextStyle(
                              color: Appstyle.MainColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                userEmail,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Menu Items Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItemWidget(
                          icon: Icons.location_on_outlined,
                          iconColor: Appstyle.MainColor,
                          title: "Delivery Address",
                          subtitle: address != null
                              ? address.fullAddress
                              : "Tap to set delivery address",
                          onTap: () => _showEditAddress(address),
                        ),
                        const Divider(height: 1, indent: 60),
                        ProfileMenuItemWidget(
                          icon: Icons.receipt_long_outlined,
                          iconColor: Colors.deepPurple,
                          title: "My Orders",
                          subtitle: "Track, reorder and view history",
                          onTap: () {
                            navigateSmoothly(context, const clsOrdersScreen());
                          },
                        ),
                        const Divider(height: 1, indent: 60),
                        ProfileMenuItemWidget(
                          icon: Icons.credit_card_outlined,
                          iconColor: Colors.blueAccent,
                          title: "Payment Methods",
                          subtitle: "Credit card, Cash on delivery",
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Cash on Delivery selected"),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 60),
                        ProfileMenuItemWidget(
                          icon: Icons.notifications_none_outlined,
                          iconColor: Colors.amber.shade700,
                          title: "Notifications",
                          subtitle: "Offers, order status updates",
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 60),
                        ProfileMenuItemWidget(
                          icon: Icons.help_outline_rounded,
                          iconColor: Colors.teal,
                          title: "Help & Support",
                          subtitle: "FAQ, Live support chat",
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 60),
                        ProfileMenuItemWidget(
                          icon: Icons.logout_rounded,
                          isDestructive: true,
                          title: "Log Out",
                          subtitle: "Sign out of this account",
                          onTap: () {
                            AuthSession.clear();
                            navigateSmoothly(
                              context,
                              const clsLoginScreen(),
                              clearStack: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
