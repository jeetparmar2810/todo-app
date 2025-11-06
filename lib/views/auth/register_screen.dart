import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_input_field.dart';
import '../../core/utils/validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registerTitle)),
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
                text: AppStrings.registerButton,
                loading: authVM.loading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authVM.signUp(
                        context, emailCtrl.text, passwordCtrl.text);

                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(AppStrings.alreadyHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}