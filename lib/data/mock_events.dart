import '../models/event.dart';

/// Predefined list of campus events meeting assignment criteria.
List<Event> getInitialMockEvents() {
  return [
    Event(
      id: 'ev-1',
      title: 'Campus Hackathon 2026',
      category: 'Technology',
      dateTime: DateTime(2026, 11, 6, 9, 0),
      venue: 'Engineering Building, Hall 101',
      description:
          'Join our 24-hour campus hackathon! Collaborate with fellow students to build innovative software solutions, meet mentors from top tech companies, and win exciting prizes. Food and drinks are provided.',
      imagePath: 'assets/images/tech_hackathon.jpg',
      totalCapacity: 60,
      availablePlaces: 18,
    ),
    Event(
      id: 'ev-2',
      title: 'Autumn Contemporary Art Exhibition',
      category: 'Arts',
      dateTime: DateTime(2026, 11, 10, 13, 30),
      venue: 'Fine Arts Center, Gallery B',
      description:
          'Explore unique artwork, oil paintings, and sculptures created by our talented student artists and faculty members. Light refreshments and live music will accompany the grand reception.',
      imagePath: 'assets/images/art_exhibition.jpg',
      totalCapacity: 40,
      availablePlaces: 1, // Exactly 1 place available
    ),
    Event(
      id: 'ev-3',
      title: 'Inter-Faculty Basketball Championship',
      category: 'Sports',
      dateTime: DateTime(2026, 11, 14, 17, 0),
      venue: 'Main Campus Sports Complex',
      description:
          'Cheer for your faculty team in the grand finals of the annual campus basketball tournament. Exciting halftime shows and merchandise giveaways included for all registered attendees.',
      imagePath: 'assets/images/sports_tournament.jpg',
      totalCapacity: 150,
      availablePlaces: 0, // Initially FULL
    ),
    Event(
      id: 'ev-4',
      title: 'Campus Acoustic Music Evening',
      category: 'Arts',
      dateTime: DateTime(2026, 11, 18, 19, 0),
      venue: 'Student Activity Center Stage',
      description:
          'An intimate night of acoustic music, indie performances, and open-mic opportunities for student songwriters. Free coffee and tea will be served throughout the evening.',
      imagePath: 'assets/images/music_fest.jpg',
      totalCapacity: 80,
      availablePlaces: 35,
    ),
    Event(
      id: 'ev-5',
      title: 'AI & Machine Learning Hands-on Workshop',
      category: 'Technology',
      dateTime: DateTime(2026, 11, 22, 14, 0),
      venue: 'Computer Engineering Lab 3',
      description:
          'Learn the fundamentals of deep learning, generative AI, and agentic workflows. Hands-on coding session using Python and Flutter. Please bring your laptop with development tools installed.',
      imagePath: 'assets/images/ai_workshop.jpg',
      totalCapacity: 35,
      availablePlaces: 12,
    ),
    Event(
      id: 'ev-6',
      title: 'Annual Alumni & Career Networking Mixer',
      category: 'Career',
      dateTime: DateTime(2026, 11, 28, 15, 30),
      venue: 'Central Conference Hall',
      description:
          'Connect with successful university alumni working in leading global firms. Gain valuable career insights, 1-on-1 resume reviews, and direct internship networking opportunities.',
      imagePath: 'assets/images/career_networking.jpg',
      totalCapacity: 100,
      availablePlaces: 54,
    ),
  ];
}
