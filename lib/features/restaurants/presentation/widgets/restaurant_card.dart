import 'package:flutter/material.dart';
import 'package:halal_dublin/core/theme/app_colors.dart';
import 'package:halal_dublin/core/theme/app_text_styles.dart';
import 'package:halal_dublin/features/restaurants/data/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder with gradient and icon
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
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
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Rating row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.ratingBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ratingGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Address
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tags and Halal badge
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      ...?restaurant.cuisine
                          ?.take(2)
                          .map((cuisine) => _Tag(label: cuisine)),
                      if (restaurant.isHalalCertified == true)
                        _HalalBadge(
                          certification: restaurant.halalCertification,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCuisineEmoji(String? cuisine) {
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

class _HalalBadge extends StatelessWidget {
  final String? certification;
  const _HalalBadge({this.certification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✓', style: TextStyle(color: Colors.white, fontSize: 9)),
          const SizedBox(width: 3),
          Text(
            'Halal${certification != null ? ' – $certification' : ''}',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
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
