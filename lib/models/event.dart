/// Data model representing a campus event.
class Event {
  final String id;
  final String title;
  final String category;
  final DateTime dateTime;
  final String venue;
  final String description;
  final String imagePath;
  final int totalCapacity;
  int availablePlaces;
  bool isFavorite;
  bool isJoined;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.imagePath,
    required this.totalCapacity,
    required this.availablePlaces,
    this.isFavorite = false,
    this.isJoined = false,
  });

  /// True if there are no available seats left.
  bool get isFull => availablePlaces <= 0;

  /// Formatted date string for user display.
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$month $day, $year • $hour:$minute';
  }
}
