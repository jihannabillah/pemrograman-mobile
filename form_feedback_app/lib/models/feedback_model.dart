class FeedbackModel {
  String name;
  String comment;
  int rating;
  DateTime date;

  FeedbackModel({
    required this.name,
    required this.comment,
    required this.rating,
    required this.date,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}