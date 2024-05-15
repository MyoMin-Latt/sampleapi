import 'package:flutter/cupertino.dart';
import 'package:sampleapi/student/presentation/page/page.dart';
import 'package:sampleapi/student/presentation/presentation.dart';
import 'package:sampleapi/student/student.dart';

class Routing {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashPage.route:
        return pageRouter(page: const SplashPage());

      case LoginPage.route:
        return pageRouter(page: const LoginPage());

      case RegisterPage.route:
        return pageRouter(page: const RegisterPage());

      default:
        return pageRouter(page: const SplashPage());
    }
  }

  static pageRouter({required Widget page}) => CupertinoPageRoute(
        builder: (_) => page,
      );
}
