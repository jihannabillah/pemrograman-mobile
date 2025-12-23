class TravelPlan {
  int? id;
  String heritageName;
  String heritageCountry;
  String heritageImage;
  DateTime planDate;
  String notes;
  String status;
  double budget;
  int? rating; // Tambahkan ini jika di DB ada kolom rating

  TravelPlan({
    this.id,
    required this.heritageName,
    required this.heritageCountry,
    required this.heritageImage,
    required this.planDate,
    this.notes = '',
    this.status = 'planned',
    this.budget = 0.0,
    this.rating,
  });

  // Convert ke Map untuk Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'heritageName': heritageName,
      'heritageCountry': heritageCountry,
      'heritageImage': heritageImage,
      'planDate': planDate.toIso8601String(), // Penting: Simpan tanggal sebagai String
      'notes': notes,
      'status': status,
      'budget': budget,
      'rating': rating,
    };
  }

  // Convert dari Map Database ke Object
  factory TravelPlan.fromMap(Map<String, dynamic> map) {
    return TravelPlan(
      id: map['id'],
      heritageName: map['heritageName'] ?? '',
      heritageCountry: map['heritageCountry'] ?? '',
      heritageImage: map['heritageImage'] ?? '',
      planDate: DateTime.parse(map['planDate']), // Parse string balik ke DateTime
      notes: map['notes'] ?? '',
      status: map['status'] ?? 'planned',
      budget: map['budget']?.toDouble() ?? 0.0,
      rating: map['rating'],
    );
  }
}