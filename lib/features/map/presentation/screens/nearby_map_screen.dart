import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:halal_dublin/app/router.dart';
import 'package:halal_dublin/core/services/cached_tile_provider.dart';
import 'package:halal_dublin/core/theme/app_colors.dart';
import 'package:halal_dublin/core/theme/app_spacing.dart';
import 'package:halal_dublin/features/map/providers/location_provider.dart';
import 'package:halal_dublin/features/restaurants/data/models/restaurant.dart';
import 'package:halal_dublin/features/restaurants/providers/restaurant_providers.dart';
import 'package:latlong2/latlong.dart';

class NearbyMapScreen extends ConsumerStatefulWidget {
  const NearbyMapScreen({super.key});

  @override
  ConsumerState<NearbyMapScreen> createState() => _NearbyMapScreenState();
}

class _NearbyMapScreenState extends ConsumerState<NearbyMapScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(restaurantsProvider);
    final currentPositionAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToCurrentLocation,
            tooltip: 'Go to my location',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          restaurantsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
            data: (restaurants) {
              // Default center: Dublin city center
              final defaultCenter = const LatLng(53.3498, -6.2603);

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: defaultCenter,
                  initialZoom: 13.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  // OpenStreetMap tile layer
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.yourname.halaldublin',
                    // Important: Respect OSM's tile usage policy
                    tileProvider: CachedTileProvider(),
                  ),
                  // Restaurant markers
                  MarkerLayer(
                    markers: restaurants
                        .where((r) => r.latitude != null && r.longitude != null)
                        .map((restaurant) {
                          final latLng = LatLng(
                            restaurant.latitude!,
                            restaurant.longitude!,
                          );
                          return Marker(
                            point: latLng,
                            width: 80,
                            height: 80,
                            child: GestureDetector(
                              onTap: () {
                                context.push(
                                  AppRoutes.restaurantDetailPath(restaurant.id),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.restaurant,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      restaurant.name,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                  // Current location marker (if available)
                  currentPositionAsync.when(
                    data: (position) {
                      if (position == null) return const SizedBox.shrink();
                      return MarkerLayer(
                        markers: [
                          Marker(
                            point: position,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
          // Loading overlay for location
          currentPositionAsync.when(
            loading: () => const Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Getting location...'),
                    ],
                  ),
                ),
              ),
            ),
            data: (_) => const SizedBox.shrink(),
            error: (error, _) => Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: Card(
                color: AppColors.error.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Could not get location. Showing Dublin area.',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.invalidate(currentPositionProvider);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  void _goToCurrentLocation() async {
    final position = ref.read(currentPositionProvider).value;
    if (position != null) {
      _mapController.move(position, 15.0);
    } else {
      // Try to refresh location
      ref.invalidate(currentPositionProvider);
    }
  }

  // Temporary: Convert address to approximate LatLng
  // In production, store coordinates in Supabase
  // lib/features/map/presentation/screens/nearby_map_screen.dart

  // Temporary hardcoded coordinates for our 5 restaurants
  // In production, store these in Supabase
  LatLng? _getRestaurantLatLng(Restaurant restaurant) {
    if (restaurant.latitude != null && restaurant.longitude != null) {
      return LatLng(restaurant.latitude!, restaurant.longitude!);
    }
    return null; // Restaurant has no coordinates
  }
}
