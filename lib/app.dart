import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_jitendra/core/constants/app_strings.dart';

import 'core/theme/app_theme.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'services/connectivity_service.dart';
import 'services/retry_service.dart';

import 'routes/app_routes.dart';
import 'routes/app_router.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authViewModelProvider);
    final isLoggedIn = authVM.currentUser != null;

    return Consumer(
      builder: (context, ref, child) {
        final onlineAsync = ref.watch(connectivityProvider);
        onlineAsync.whenData((online) {
          if (online) RetryService.instance.processQueue();
        });
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
