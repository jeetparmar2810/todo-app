import 'package:flutter/material.dart';
import 'package:todo_app_jitendra/core/constants/app_strings.dart';
import 'package:todo_app_jitendra/views/auth/register_screen.dart';
import 'package:todo_app_jitendra/views/auth/login_screen.dart';
import 'package:todo_app_jitendra/views/home/home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.login:
        return _fade(const LoginScreen());

      case AppRoutes.register:
        return _fade(const RegisterScreen());

      case AppRoutes.home:
        return _fade(const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(AppStrings.noRoute),
            ),
          ),
        );
    }
  }

  static PageRoute _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}