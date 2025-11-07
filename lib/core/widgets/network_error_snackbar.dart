import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class NetworkError {
  static void show({
    required BuildContext context,
    required VoidCallback onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                AppStrings.noInternetConnection,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: AppStrings.retry,
          textColor: Colors.white,
          onPressed: onRetry,
        ),
      ),
    );
  }
}