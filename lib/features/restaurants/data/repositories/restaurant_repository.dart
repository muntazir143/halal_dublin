import 'package:halal_dublin/features/restaurants/data/models/restaurant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantRepository {
  final SupabaseClient _client;
  RestaurantRepository({required SupabaseClient client}) : _client = client;

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _client
          .from("restaurants")
          .select()
          .order("name", ascending: true);
      return response
          .map<Restaurant>((json) => Restaurant.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  Future<Restaurant> getRestaurantById(String id) async {
    try {
      final response = await _client
          .from('restaurants')
          .select()
          .eq('id', id)
          .single();

      return Restaurant.fromJson(response);
    } catch (e) {
      throw Exception('Restaurant not found');
    }
  }
}
