import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/validators.dart';
import 'package:otlop_1/screens/MainNavigationScreen.dart';
import 'package:otlop_1/screens/auth/LoginScreesn.dart';
import 'package:otlop_1/screens/auth/cubit/auth_cubit.dart';
import 'package:otlop_1/screens/auth/cubit/auth_state.dart';
import 'package:otlop_1/widgets/HeaderRegister.dart';
import 'package:otlop_1/widgets/RemberRow.dart';
import 'package:otlop_1/widgets/SocialLoginSection.dart';
import 'package:otlop_1/widgets/customElvetdButton.dart';
import 'package:otlop_1/widgets/getUserInfo.dart';
import 'package:otlop_1/widgets/smooth_page_route.dart';

class clsRegisterScreen extends StatefulWidget {
  const clsRegisterScreen({super.key});

  @override
  State<clsRegisterScreen> createState() => _clsRegisterScreenState();
}

class _clsRegisterScreenState extends State<clsRegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _goToHome() {
    navigateSmoothly(
      context,
      const MainNavigationScreen(initialIndex: 0),
      clearStack: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Account created successfully! Welcome, ${state.user.displayName ?? 'Foodie'}! 🎉",
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
                _goToHome();
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoadingState;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const clsHeaderMessage(
                        mainText: "Create an account",
                        supText: "Connect with your friends today!",
                      ),
                      const SizedBox(height: 20),
                      clsUserInfo(
                        TextLab: "Full Name",
                        hintText: "Enter your full name",
                        controller: nameController,
                        validator: Validator.validateName,
                      ),
                      clsUserInfo(
                        TextLab: "Email Address",
                        hintText: "Enter your email",
                        controller: emailController,
                        validator: Validator.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      clsUserInfo(
                        TextLab: "Phone Number",
                        hintText: "Enter your phone number (01...)",
                        controller: phoneController,
                        validator: Validator.validatePhoneNumber,
                        keyboardType: TextInputType.phone,
                      ),
                      clsUserInfo(
                        TextLab: "Password",
                        hintText: "Enter your password",
                        controller: passController,
                        validator: Validator.validatePassword,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      const clsRemmberMeRow(),
                      const SizedBox(height: 20),
                      clsCustomElvetdButton(
                        BText: "Sign Up",
                        isLoading: isLoading,
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<AuthCubit>().register(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  password: passController.text,
                                );
                          }
                        },
                      ),
                      clsSocialLoginSection(
                        maiText: "Log In",
                        supText: "Already have an account?",
                        onPressedLink: () {
                          navigateSmoothly(
                            context,
                            const clsLoginScreen(),
                            replace: true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
