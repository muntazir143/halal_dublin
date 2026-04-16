import 'package:go_router/go_router.dart';
import 'package:halal_dublin/features/home/presentation/screens/home_screen.dart';
import 'package:halal_dublin/features/restaurants/presentation/screens/restaurant_detail_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String restaurantDetail = '/restaurant/:id';
  static String restaurantDetailPath(String id) => '/restaurant/$id';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.restaurantDetail,
      name: 'restaurantDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RestaurantDetailScreen(restaurantId: id);
      },
    ),
  ],
);
