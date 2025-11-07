import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';

class LogoutSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutSheet({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),

        /// Title
        const Text(
          AppStrings.logoutTooltip,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        /// Subtitle
        const Text(
          AppStrings.logoutMsg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 25),

        /// Logout button
        CustomButton(
          text: AppStrings.logoutTooltip,
          onPressed: onConfirm,
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
