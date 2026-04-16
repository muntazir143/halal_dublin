// lib/core/services/cached_tile_provider.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class CachedTileProvider extends TileProvider {
  CachedTileProvider();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    // Ensure urlTemplate is not null
    final template = options.urlTemplate;
    if (template == null) {
      throw Exception('TileLayer must have a urlTemplate');
    }

    final url = template
        .replaceFirst('{z}', coordinates.z.toString())
        .replaceFirst('{x}', coordinates.x.toString())
        .replaceFirst('{y}', coordinates.y.toString());

    return CachedNetworkImageProvider(url);
  }
}
