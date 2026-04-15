class Restaurant {
  final String id;
  final String name;
  final String address;
  final double rating;
  final List<String>? cuisine;
  final bool? isHalalCertified;
  final String? halalCertification;
  final String? phone;
  final String? website;
  final String? imageUrl;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    this.cuisine,
    this.isHalalCertified,
    this.halalCertification,
    this.phone,
    this.website,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, rating: $rating)';
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      cuisine: json['cuisine'] != null
          ? List<String>.from(json['cuisine'] as List)
          : null,
      isHalalCertified: json['is_halal_certified'] as bool?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
