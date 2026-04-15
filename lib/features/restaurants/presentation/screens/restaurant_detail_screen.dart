import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halal_dublin/core/theme/app_colors.dart';
import 'package:halal_dublin/core/theme/app_spacing.dart';
import 'package:halal_dublin/core/theme/app_text_styles.dart';
import 'package:halal_dublin/features/restaurants/providers/restaurant_providers.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String restaurantId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(restaurantDetailProvider(restaurantId));

    return Scaffold(
      appBar: AppBar(
        title: restaurantAsync.maybeWhen(
          data: (restaurant) => Text(restaurant.name),
          orElse: () => const Text('Loading...'),
        ),
      ),
      body: restaurantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text('Error loading restaurant', style: AppTextStyles.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error.toString(),
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (restaurant) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.lg),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.secondary,
                          size: 32,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Address
                _buildInfoSection(
                  icon: Icons.location_on,
                  title: 'Address',
                  content: restaurant.address,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Cuisine (if available)
                if (restaurant.cuisine != null &&
                    restaurant.cuisine!.isNotEmpty)
                  _buildInfoSection(
                    icon: Icons.restaurant,
                    title: 'Cuisine',
                    content: restaurant.cuisine!.join(', '),
                  ),
                const SizedBox(height: AppSpacing.lg),

                // Phone (if available)
                if (restaurant.phone != null)
                  _buildInfoSection(
                    icon: Icons.phone,
                    title: 'Phone',
                    content: restaurant.phone!,
                  ),
                const SizedBox(height: AppSpacing.lg),

                // Website (if available)
                if (restaurant.website != null)
                  _buildInfoSection(
                    icon: Icons.language,
                    title: 'Website',
                    content: restaurant.website!,
                  ),
                const SizedBox(height: AppSpacing.lg),

                // Halal Certification
                if (restaurant.isHalalCertified == true) ...[
                  const Divider(),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, color: AppColors.success),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halal Certified',
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                              if (restaurant.halalCertification != null)
                                Text(
                                  'Certification: ${restaurant.halalCertification}',
                                  style: AppTextStyles.bodyMedium,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                content,
                style: AppTextStyles.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
