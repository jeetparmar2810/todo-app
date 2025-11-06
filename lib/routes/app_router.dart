import 'package:flutter/material.dart';
import 'package:todo_app_jitendra/core/constants/app_strings.dart';
import 'package:todo_app_jitendra/views/auth/register_screen.dart';

import '../views/auth/login_screen.dart';
import '../views/home/home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
          const Scaffold(body: Center(child: Text(AppStrings.noRoute))),
        );
    }
  }
}