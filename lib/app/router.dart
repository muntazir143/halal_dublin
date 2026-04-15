import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:halal_dublin/features/restaurants/presentation/screens/restaurant_detail_screen.dart';
import 'package:halal_dublin/features/restaurants/presentation/screens/restaurant_list_screen.dart';

class AppRoutes {
  static const String home = "/";
  static const String restaurantDetail = "/restaurant/:id";
  static String restaurantDetailPath(String id) => "/restaurant/$id";
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: "home",
      builder: (context, state) => const RestaurantListScreen(),
    ),
    GoRoute(
      path: AppRoutes.restaurantDetail,
      name: "restaurantDetail",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return RestaurantDetailScreen(restaurantId: id);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
