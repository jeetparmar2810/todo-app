import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/constants/app_strings.dart';

class ExitAppSheet extends StatelessWidget {
  const ExitAppSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ExitAppSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          /// Exit Icon
          Icon(
            Icons.exit_to_app_rounded,
            size: 60,
            color: Colors.deepPurple[400],
          ),

          const SizedBox(height: 16),

          /// Title
          const Text(
            AppStrings.exitApp,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          /// Subtitle
          const Text(
            AppStrings.exitAppConfirmation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 25),

          /// Exit button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: AppStrings.exit,
              onPressed: () {
                Navigator.pop(context, true);
                SystemNavigator.pop();
              },
            ),
          ),

          const SizedBox(height: 10),

          /// Cancel button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}