import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:halal_dublin/core/services/supabase_service.dart';
import 'package:halal_dublin/features/restaurants/data/models/restaurant.dart';
import 'package:halal_dublin/features/restaurants/data/repositories/restaurant_repository.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) {
    final client = ref.read(supabaseClientProvider);
    return RestaurantRepository(client: client);
  },
);

final restaurantsProvider = FutureProvider<List<Restaurant>>(
  (ref) async {
    final repository = ref.read(restaurantRepositoryProvider);
    return repository.getRestaurants();
  },
);

final restaurantDetailProvider = FutureProvider.family<Restaurant, String>(
  (ref, id) {
    final repository = ref.read(restaurantRepositoryProvider);
    return repository.getRestaurantById(id);
  },
);

final searchQueryProvider = StateProvider<String>(
  (ref) => "",
);

final filteredRestaurantsProvider = Provider<List<Restaurant>>(
  (ref) {
    final restaurantsAsync = ref.watch(restaurantsProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase().toString();

    return restaurantsAsync.when(
      data: (restaurants) {
        if (searchQuery.isEmpty) {
          return restaurants;
        }
        return restaurants.where((restaurant) {
          return restaurant.name.toLowerCase().contains(searchQuery) ||
              restaurant.address.toLowerCase().contains(searchQuery);
        }).toList();
      },
      error: (_, _) => [],
      loading: () => [],
    );
  },
);
