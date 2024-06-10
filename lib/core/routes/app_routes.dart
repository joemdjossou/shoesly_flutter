import 'package:flutter/material.dart';
import 'package:shoesly_flutter/core/screens/all_reviews_page.dart';
import 'package:shoesly_flutter/core/screens/cart_page.dart';
import 'package:shoesly_flutter/core/screens/checkout_page.dart';
import 'package:shoesly_flutter/core/screens/discover_page.dart';
import 'package:shoesly_flutter/core/screens/shoe_details.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //Discover Page Route
      case DiscoverPage.id:
        return MaterialPageRoute(
          builder: (_) => const DiscoverPage(),
        );

      // Shoes details Route
      case ShoeDetails.id:
        return MaterialPageRoute(
          builder: (_) => const ShoeDetails(),
        );

      // All Reviews Page Route
      case ReviewsPage.id:
        return MaterialPageRoute(
          builder: (_) => ReviewsPage(),
        );

      // Cart Page Route
      case CartPage.id:
        return MaterialPageRoute(
          builder: (_) => const CartPage(),
        );

      // Check Out Page Route
      case CheckoutPage.id:
        return MaterialPageRoute(
          builder: (_) => const CheckoutPage(),
        );

      // default error message
      default:
        return MaterialPageRoute(
          builder: (_) => const Text('Error: Route not found'),
        );
    }
  }
}
