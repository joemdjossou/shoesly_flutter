import 'package:flutter/material.dart';
import 'package:shoesly_flutter/core/screens/discover_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DiscoverPage.id:
        return MaterialPageRoute(
          builder: (_) => const DiscoverPage(),
        );

      // case SplashScreen.id:
      //   return MaterialPageRoute(
      //     builder: (_) => const SplashScreen(),
      //   );
      //
      // case MainScreen.id:
      //   return MaterialPageRoute(
      //     builder: (_) => const MainScreen(),
      //   );

      // Add more routes for other screens as needed
      default:
        return MaterialPageRoute(
          builder: (_) => const Text('Error: Route not found'),
        );
    }
  }
}
