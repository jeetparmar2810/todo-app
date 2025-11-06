import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_jitendra/core/constants/app_strings.dart';

final connectivityProvider = StreamProvider.autoDispose<bool>((ref) {
  final controller = StreamController<bool>.broadcast();
  final connectivity = Connectivity();

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup(AppStrings.googleDns)
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
  checkInternet().then(controller.add);
  final sub = connectivity.onConnectivityChanged.listen((event) async {
    if (event == ConnectivityResult.none) {
      controller.add(false);
    } else {
      final online = await checkInternet();
      controller.add(online);
    }
  });
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
