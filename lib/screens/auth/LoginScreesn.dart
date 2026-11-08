import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/validators.dart';
import 'package:otlop_1/screens/MainNavigationScreen.dart';
import 'package:otlop_1/screens/auth/RegisterScreen.dart';
import 'package:otlop_1/screens/auth/cubit/auth_cubit.dart';
import 'package:otlop_1/screens/auth/cubit/auth_state.dart';
import 'package:otlop_1/widgets/HeaderRegister.dart';
import 'package:otlop_1/widgets/RemberRow.dart';
import 'package:otlop_1/widgets/SocialLoginSection.dart';
import 'package:otlop_1/widgets/customElvetdButton.dart';
import 'package:otlop_1/widgets/getUserInfo.dart';
import 'package:otlop_1/widgets/smooth_page_route.dart';

class clsLoginScreen extends StatefulWidget {
  const clsLoginScreen({super.key});

  @override
  State<clsLoginScreen> createState() => _clsLoginScreenState();
}

class _clsLoginScreenState extends State<clsLoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                      "Welcome back, ${state.user.displayName ?? 'Foodie'}! 👋",
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
                        mainText: "Hi, Welcome Back! 👋",
                        supText: "Hello again, you've been missed!",
                      ),
                      const SizedBox(height: 24),
                      clsUserInfo(
                        TextLab: "Email",
                        hintText: "Enter your email address",
                        controller: emailController,
                        validator: Validator.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      clsUserInfo(
                        TextLab: "Password",
                        hintText: "Enter your password",
                        controller: passController,
                        validator: Validator.validateLoginPassword,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      const clsRemmberMeRow(),
                      const SizedBox(height: 24),
                      clsCustomElvetdButton(
                        BText: "Log In",
                        isLoading: isLoading,
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<AuthCubit>().login(
                                  emailController.text,
                                  passController.text,
                                );
                          }
                        },
                      ),
                      clsSocialLoginSection(
                        maiText: "Sign Up",
                        supText: "Don't have an account?",
                        onPressedLink: () {
                          navigateSmoothly(
                            context,
                            const clsRegisterScreen(),
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
