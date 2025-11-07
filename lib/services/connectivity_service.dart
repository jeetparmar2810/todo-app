import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_jitendra/core/constants/app_strings.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      final result = await InternetAddress.lookup(AppStrings.googleDns)
          .timeout(const Duration(seconds: 5));

      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});