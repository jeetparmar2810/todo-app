import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_input_field.dart';
import '../../core/utils/validators.dart';
import '../../core/constants/app_strings.dart';

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
  Widget build(BuildContext context) {
    final authVM = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInputField(
                label: AppStrings.email,
                controller: emailCtrl,
                validator: Validators.emailValidator,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: AppStrings.password,
                controller: passwordCtrl,
                obscureText: true,
                validator: Validators.passwordValidator,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.loginButton,
                loading: authVM.loading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await authVM.signIn(
                      context,
                      emailCtrl.text,
                      passwordCtrl.text,
                    );

                    if (!mounted) return;

                    if (success) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                            (route) => false,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                child: const Text(AppStrings.dontHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}