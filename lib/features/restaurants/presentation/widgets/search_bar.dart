// lib/features/restaurants/presentation/widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/restaurant_providers.dart';

class RestaurantSearchBar extends ConsumerWidget {
  const RestaurantSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchNotifier = ref.read(searchQueryProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by name or address...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => searchNotifier.state = '',
                )
              : null,
        ),
        onChanged: (value) => searchNotifier.state = value,
      ),
    );
  }
}
