class Country {
  final String name;
  final String flagUrl;
  final String capital;
  final String region;
  final int population;

  Country({
    required this.name,
    required this.flagUrl,
    required this.capital,
    required this.region,
    required this.population,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'Unknown',
      flagUrl: json['flags']['png'] ?? '',
      capital: (json['capital'] as List<dynamic>?)?.first ?? 'Unknown',
      region: json['region'] ?? 'Unknown',
      population: json['population'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flags': {'png': flagUrl},
      'capital': [capital],
      'region': region,
      'population': population,
    };
  }
}