import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'services/connectivity_service.dart';
import 'services/retry_service.dart';

import 'routes/app_routes.dart';
import 'routes/app_router.dart';

class TodoApp extends ConsumerStatefulWidget {
  const TodoApp({super.key});

  @override
  ConsumerState<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends ConsumerState<TodoApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final service = ref.read(connectivityServiceProvider);
      final online = await service.hasInternetConnection();
      if (online) {
        RetryService.instance.processQueue();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = ref.watch(authViewModelProvider);
    final isLoggedIn = authVM.currentUser != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
