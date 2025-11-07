import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_input_field.dart';
import '../../core/utils/validators.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimens.dart';
import '../../services/connectivity_service.dart';
import '../../core/widgets/network_error_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final connectivityService = ref.read(connectivityServiceProvider);
    final hasInternet = await connectivityService.hasInternetConnection();

    if (!hasInternet) {
      if (!mounted) return;

      NetworkError.show(
        context: context,
        onRetry: _handleLogin,
      );
      return;
    }

    final authVM = ref.read(authViewModelProvider);

    final success = await authVM.signIn(
      context,
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = ref.watch(authViewModelProvider);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 90,
                color: Colors.deepPurple.shade400,
              ),

              const SizedBox(height: AppDimens.space24),

              Text(
                AppStrings.loginTitle,
                style: TextStyle(
                  fontSize: AppDimens.responsiveFont(
                      AppDimens.fontXXLarge, deviceWidth),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: AppDimens.space10),

              Text(
                AppStrings.loginSubtitle,
                style: TextStyle(
                  fontSize:
                  AppDimens.responsiveFont(AppDimens.fontMedium, deviceWidth),
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: AppDimens.space32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputField(
                      label: AppStrings.email,
                      controller: emailCtrl,
                      prefixIcon: Icons.email,
                      validator: Validators.emailValidator,
                    ),

                    const SizedBox(height: AppDimens.space16),

                    CustomInputField(
                      label: AppStrings.password,
                      controller: passwordCtrl,
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: Validators.passwordValidator,
                    ),

                    const SizedBox(height: AppDimens.space24),


                    SizedBox(
                      width: double.infinity,
                      height: AppDimens.buttonHeight,
                      child: CustomButton(
                        text: AppStrings.loginButton,
                        loading: authVM.loading,
                        onPressed: _handleLogin,
                      ),
                    ),

                    const SizedBox(height: AppDimens.space24),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.dontHaveAccountOnly,
                          style: TextStyle(
                            fontSize: AppDimens.fontRegular,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          child: Text(
                            AppStrings.registerTitle,
                            style: TextStyle(
                              fontSize: AppDimens.fontMedium,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}