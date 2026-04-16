import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halal_dublin/features/restaurants/providers/restaurant_providers.dart';

class RestaurantSearchBar extends ConsumerWidget {
  const RestaurantSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchNotifier = ref.read(searchQueryProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search restaurants, cuisines...',
          prefixIcon: const Icon(Icons.search, size: 18),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => searchNotifier.state = '',
                )
              : null,
        ),
        onChanged: (value) => searchNotifier.state = value,
      ),
    );
  }
}
