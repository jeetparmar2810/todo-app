import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/network_error_snackbar.dart';
import '../../services/connectivity_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_input_field.dart';
import '../../core/utils/validators.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = ref.watch(authViewModelProvider);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(AppStrings.registerTitle),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.space24),

        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              Icon(
                Icons.check_circle,
                size: 90,
                color: Colors.deepPurple.shade400,
              ),

              const SizedBox(height: AppDimens.space24),

              Text(
                AppStrings.registerTitle,
                style: TextStyle(
                  fontSize:
                  AppDimens.responsiveFont(AppDimens.fontXXLarge, deviceWidth),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: AppDimens.space32),

              CustomInputField(
                label: AppStrings.email,
                controller: emailCtrl,
                validator: Validators.emailValidator,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: AppDimens.space16),


              CustomInputField(
                label: AppStrings.password,
                controller: passwordCtrl,
                obscureText: true,
                validator: Validators.passwordValidator,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: AppDimens.space16),


              CustomInputField(
                label: AppStrings.confirmPassword,
                controller: confirmPassCtrl,
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  if (value != passwordCtrl.text) {
                    return AppStrings.passwordNotMatch;
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppDimens.space24),


              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeight,
                child: CustomButton(
                  text: AppStrings.registerButton,
                  loading: authVM.loading,
                  onPressed: _handleRegister
                ),
              ),

              const SizedBox(height: AppDimens.space24),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.alreadyAccount,
                    style: TextStyle(
                      fontSize: AppDimens.fontRegular,
                      color: Colors.black54,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                            (_) => false,
                      );
                    },
                    child: Text(
                      AppStrings.loginButton,
                      style: TextStyle(
                        fontSize: AppDimens.fontMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final connectivityService = ref.read(connectivityServiceProvider);
    final hasInternet = await connectivityService.hasInternetConnection();

    if (!hasInternet) {
      if (!mounted) return;

      NetworkError.show(
        context: context,
        onRetry: _handleRegister,
      );
      return;
    }
    final authVM = ref.read(authViewModelProvider);

    await authVM.signUp(
        context,
        emailCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (_) => false,
      );
    }
}
