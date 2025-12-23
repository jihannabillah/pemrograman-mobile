class Heritage {
  final int id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final String category;
  final double rating;
  final int yearInscribed;
  final String location;
  final bool isPopular;

  Heritage({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.yearInscribed,
    required this.location,
    required this.isPopular,
  });

  factory Heritage.fromJson(Map<String, dynamic> json) {
    return Heritage(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      country: json['country'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/400x300',
      category: json['category'] ?? 'Cultural',
      rating: (json['rating'] ?? 0.0).toDouble(),
      yearInscribed: json['yearInscribed'] ?? 0,
      location: json['location'] ?? 'Unknown',
      isPopular: json['popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'yearInscribed': yearInscribed,
      'location': location,
      'popular': isPopular,
    };
  }
}