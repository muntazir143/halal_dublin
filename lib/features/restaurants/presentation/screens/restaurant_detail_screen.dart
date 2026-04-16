import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:halal_dublin/core/theme/app_colors.dart';
import 'package:halal_dublin/core/theme/app_text_styles.dart';
import 'package:halal_dublin/features/restaurants/providers/restaurant_providers.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(restaurantDetailProvider(restaurantId));

    return Scaffold(
      body: restaurantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (restaurant) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: AppColors.primaryLight,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryLight,
                          AppColors.primaryLight.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getCuisineIcon(restaurant.cuisine?.firstOrNull),
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 4,
                                  children: [
                                    ...?restaurant.cuisine?.map(
                                      (c) => _Tag(label: c),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.ratingBackground,
                              border: Border.all(
                                color: AppColors.ratingGold.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const Text('⭐', style: TextStyle(fontSize: 18)),
                                Text(
                                  restaurant.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ratingGold,
                                  ),
                                ),
                                const Text(
                                  'rating',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.ratingGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Halal certification card
                      if (restaurant.isHalalCertified == true)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Halal Certified',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (restaurant.halalCertification != null)
                                    Text(
                                      'Certified by ${restaurant.halalCertification}',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Info cards
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.location_on,
                              label: 'ADDRESS',
                              value: restaurant.address,
                            ),
                            const Divider(height: 0),
                            if (restaurant.phone != null)
                              _InfoRow(
                                icon: Icons.phone,
                                label: 'PHONE',
                                value: restaurant.phone!,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getCuisineEmoji(String? cuisine) {
    // same as in RestaurantCard
    if (cuisine == null) return '🍽️';
    final lower = cuisine.toLowerCase();
    if (lower.contains('syrian') || lower.contains('middle eastern'))
      return '🧆';
    if (lower.contains('persian') || lower.contains('kebab')) return '🥙';
    if (lower.contains('falafel') || lower.contains('lebanese')) return '🧇';
    if (lower.contains('pakistani') || lower.contains('indian')) return '🍛';
    return '🍽️';
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelTiny),
              const SizedBox(height: 1),
              Text(value, style: AppTextStyles.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }
}

IconData _getCuisineIcon(String? cuisine) {
  if (cuisine == null) return Icons.restaurant;
  final lower = cuisine.toLowerCase();
  if (lower.contains('syrian') || lower.contains('middle eastern')) {
    return Icons.kebab_dining; // or Icons.food_bank
  }
  if (lower.contains('persian') || lower.contains('kebab')) {
    return Icons.kebab_dining;
  }
  if (lower.contains('falafel') || lower.contains('lebanese')) {
    return Icons.breakfast_dining; // or Icons.fastfood
  }
  if (lower.contains('pakistani') || lower.contains('indian')) {
    return Icons.rice_bowl;
  }
  return Icons.restaurant;
}
