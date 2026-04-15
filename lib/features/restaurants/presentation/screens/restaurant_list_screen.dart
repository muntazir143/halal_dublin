// lib/features/restaurants/presentation/screens/restaurant_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/restaurant_providers.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/search_bar.dart';

class RestaurantListScreen extends ConsumerWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRestaurants = ref.watch(filteredRestaurantsProvider);
    final restaurantsAsync = ref.watch(restaurantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halal Dublin'),
      ),
      body: Column(
        children: [
          const RestaurantSearchBar(),
          Expanded(
            child: restaurantsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Error: $error', textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(restaurantsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (_) {
                if (filteredRestaurants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Text('No restaurants found'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(restaurantsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = filteredRestaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        onTap: () {
                          context.push(
                            AppRoutes.restaurantDetailPath(restaurant.id),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
