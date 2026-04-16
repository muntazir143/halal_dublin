import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:halal_dublin/app/router.dart';
import 'package:halal_dublin/core/theme/app_colors.dart';
import 'package:halal_dublin/core/theme/app_text_styles.dart';
import 'package:halal_dublin/features/restaurants/presentation/widgets/restaurant_card.dart';
import 'package:halal_dublin/features/restaurants/presentation/widgets/search_bar.dart';
import 'package:halal_dublin/features/restaurants/providers/restaurant_providers.dart';

class RestaurantListScreen extends ConsumerWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantsProvider);
    final filteredRestaurants = ref.watch(filteredRestaurantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Halal Dublin',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Community',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header greeting
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Find halal food\nin Dublin ',
                      style: AppTextStyles.headlineLarge,
                    ),
                    const Icon(
                      Icons.eco,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Community-verified halal restaurants',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          // Simple search bar
          const RestaurantSearchBar(),
          // List
          Expanded(
            child: restaurantsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (_) => filteredRestaurants.isEmpty
                  ? const Center(child: Text('No restaurants found'))
                  : RefreshIndicator(
                      onRefresh: () async =>
                          ref.invalidate(restaurantsProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: filteredRestaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = filteredRestaurants[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            onTap: () => context.push(
                              AppRoutes.restaurantDetailPath(restaurant.id),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
