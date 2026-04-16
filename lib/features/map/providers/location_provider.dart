import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// Provider for location service status
final locationServiceProvider = FutureProvider<bool>((ref) async {
  return await Geolocator.isLocationServiceEnabled();
});

// Provider for location permission status
final locationPermissionProvider = FutureProvider<LocationPermission>((
  ref,
) async {
  return await Geolocator.checkPermission();
});

// Provider for current position
final currentPositionProvider = FutureProvider<LatLng?>((ref) async {
  // Check if location services are enabled
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // Check permission
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  // Get current position
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return LatLng(position.latitude, position.longitude);
});
