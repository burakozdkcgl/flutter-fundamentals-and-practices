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

  /// Occupancy ratio between 0.0 and 1.0 for visual progress bars.
  double get occupancyRate {
    if (totalCapacity <= 0) return 1.0;
    return ((totalCapacity - availablePlaces) / totalCapacity).clamp(0.0, 1.0);
  }

  /// Occupancy percentage as an integer (0 - 100).
  int get occupancyPercentage => (occupancyRate * 100).round();

  /// Total number of people who joined / registered for this event.
  int get joinedCount => (totalCapacity - availablePlaces).clamp(0, totalCapacity);

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

  /// Short date string for badges, e.g. "NOV 06"
  String get shortDate {
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$month $day';
  }

  /// Formatted time only, e.g. "09:00"
  String get timeOnly {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
