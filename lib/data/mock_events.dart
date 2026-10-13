import '../models/event.dart';

/// Predefined list of 30 realistic and diverse campus events at Eskişehir Technical University.
List<Event> getInitialMockEvents() {
  return [
    // 1. Existing events (ev-1 to ev-6 preserved for test compatibility)
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

    // 2. New Technology events
    Event(
      id: 'ev-7',
      title: 'Autonomous Drone & Robotics Summit',
      category: 'Technology',
      dateTime: DateTime(2026, 11, 30, 10, 0),
      venue: 'Aeronautics & Astronautics Hangar A',
      description:
          'Witness cutting-edge autonomous UAV flight demonstrations, robotic arm obstacle navigation, and AI computer vision showcases designed by ESTÜ engineering teams.',
      imagePath: 'assets/images/drone_robotics.jpg',
      totalCapacity: 120,
      availablePlaces: 28,
    ),
    Event(
      id: 'ev-8',
      title: 'ESTÜ Cyber Security & Ethical Hacking Day',
      category: 'Technology',
      dateTime: DateTime(2026, 12, 2, 11, 0),
      venue: 'Computer Engineering Red Auditorium',
      description:
          'Engage in live Capture The Flag (CTF) challenges, network penetration testing demos, and cryptography deep-dives led by industry cybersecurity veterans.',
      imagePath: 'assets/images/cyber_security.jpg',
      totalCapacity: 50,
      availablePlaces: 7,
    ),
    Event(
      id: 'ev-9',
      title: 'Game Development & Unreal Engine Bootcamp',
      category: 'Technology',
      dateTime: DateTime(2026, 12, 4, 13, 0),
      venue: 'Digital Media & Animation Lab',
      description:
          'Learn 3D level prototyping, physics shaders, and gameplay mechanics in Unreal Engine 5. Build and deploy your first playable indie mini-game by sunset.',
      imagePath: 'assets/images/game_dev.jpg',
      totalCapacity: 45,
      availablePlaces: 0, // FULL
    ),
    Event(
      id: 'ev-10',
      title: 'Web3 & Blockchain Architecture Forum',
      category: 'Technology',
      dateTime: DateTime(2026, 12, 6, 14, 30),
      venue: 'Science Faculty Conference Room 1',
      description:
          'Discover smart contract development, zero-knowledge proofs, and decentralized storage networks. Practical architectural walk-throughs for prospective Web3 engineers.',
      imagePath: 'assets/images/blockchain.jpg',
      totalCapacity: 75,
      availablePlaces: 31,
    ),
    Event(
      id: 'ev-11',
      title: 'Quantum Computing & Algorithms Seminar',
      category: 'Technology',
      dateTime: DateTime(2026, 12, 8, 10, 30),
      venue: 'Physics & Advanced Mathematics Amphitheater',
      description:
          'Explore qubits, quantum superposition, and Shor algorithm applications. An insightful academic primer into the next computational frontier.',
      imagePath: 'assets/images/quantum_computing.jpg',
      totalCapacity: 60,
      availablePlaces: 19,
    ),
    Event(
      id: 'ev-12',
      title: 'Mobile App Architecture & Flutter Masterclass',
      category: 'Technology',
      dateTime: DateTime(2026, 12, 10, 15, 0),
      venue: 'İki Eylül IT Learning Center',
      description:
          'Master modern state management, responsive UI layout tricks, and cross-platform native plugins in Flutter. Bring your laptop and questions.',
      imagePath: 'assets/images/flutter_dev.jpg',
      totalCapacity: 50,
      availablePlaces: 14,
    ),

    // 3. New Arts & Culture events
    Event(
      id: 'ev-13',
      title: 'Symphony Orchestra Winter Concert',
      category: 'Arts',
      dateTime: DateTime(2026, 12, 12, 19, 30),
      venue: 'Hasan Polatkan Cultural Hall',
      description:
          'An enchanting evening of classical masterpieces performed by the University Philharmonic Orchestra, featuring guest violin soloists and symphonic suites.',
      imagePath: 'assets/images/symphony_orchestra.jpg',
      totalCapacity: 220,
      availablePlaces: 42,
    ),
    Event(
      id: 'ev-14',
      title: 'Student Theater: Shakespeare & Modern Drama',
      category: 'Arts',
      dateTime: DateTime(2026, 12, 14, 18, 0),
      venue: 'Main Campus Black Box Theater',
      description:
          'Experience a breathtaking student-directed rendition blending classical Elizabethan drama with contemporary experimental stage lighting and sound design.',
      imagePath: 'assets/images/theater_drama.jpg',
      totalCapacity: 90,
      availablePlaces: 4,
    ),
    Event(
      id: 'ev-15',
      title: 'Architectural Model & Industrial Design Expo',
      category: 'Arts',
      dateTime: DateTime(2026, 12, 16, 11, 0),
      venue: 'Architecture Faculty Exhibition Atrium',
      description:
          'Showcase of sustainable urban dwellings, parametric timber structures, and ergonomic consumer products handcrafted by architecture students.',
      imagePath: 'assets/images/design_expo.jpg',
      totalCapacity: 110,
      availablePlaces: 58,
    ),
    Event(
      id: 'ev-16',
      title: 'Campus & Street Photography Masterclass',
      category: 'Arts',
      dateTime: DateTime(2026, 12, 18, 14, 0),
      venue: 'Communication & Media Studio',
      description:
          'Learn manual camera exposure, portrait lighting setups, and urban storytelling. Includes an interactive campus photo walk with professional critique.',
      imagePath: 'assets/images/photography.jpg',
      totalCapacity: 30,
      availablePlaces: 2,
    ),
    Event(
      id: 'ev-17',
      title: 'ESTÜ Cinema Nights: Independent Film Festival',
      category: 'Arts',
      dateTime: DateTime(2026, 12, 20, 20, 0),
      venue: 'Student Union Cinema Hall',
      description:
          'Screenings of award-winning student short films and documentary features followed by live director Q&A sessions and complimentary popcorn.',
      imagePath: 'assets/images/cinema_film.jpg',
      totalCapacity: 85,
      availablePlaces: 26,
    ),

    // 4. New Sports & Recreation events
    Event(
      id: 'ev-18',
      title: 'Inter-University Volleyball Championship',
      category: 'Sports',
      dateTime: DateTime(2026, 12, 22, 16, 0),
      venue: 'İki Eylül Indoor Sports Arena',
      description:
          'Watch the top university volleyball teams face off in high-intensity spike rallies for the regional championship trophy. Come cheer with us!',
      imagePath: 'assets/images/volleyball.jpg',
      totalCapacity: 200,
      availablePlaces: 80,
    ),
    Event(
      id: 'ev-19',
      title: 'Campus Football League Super Final',
      category: 'Sports',
      dateTime: DateTime(2026, 12, 24, 18, 30),
      venue: 'ESTÜ Central Stadium Field',
      description:
          'The climax of the semester! Engineering vs. Economics in a high-stakes final derby under stadium floodlights. Chants, band, and celebratory medals.',
      imagePath: 'assets/images/football_soccer.jpg',
      totalCapacity: 350,
      availablePlaces: 112,
    ),
    Event(
      id: 'ev-20',
      title: 'E-Sports Winter Masters: LoL & CS2',
      category: 'Sports',
      dateTime: DateTime(2026, 12, 26, 12, 0),
      venue: 'Student Center Gaming Arena',
      description:
          'Competitive LAN tournament featuring campus teams battling in 5v5 tactical clashes. Live caster commentary, sponsor gaming mice prizes, and energy drinks.',
      imagePath: 'assets/images/esports.jpg',
      totalCapacity: 120,
      availablePlaces: 0, // FULL
    ),
    Event(
      id: 'ev-21',
      title: 'ESTÜ Rowing & Water Sports Showcase',
      category: 'Sports',
      dateTime: DateTime(2026, 12, 28, 10, 0),
      venue: 'Porsuk River Water Sports Pier',
      description:
          'Early morning scull and eight-rower speed exhibition on Porsuk stream. Demonstrations, beginner rowing technique tutorials, and warm salep.',
      imagePath: 'assets/images/rowing_sports.jpg',
      totalCapacity: 60,
      availablePlaces: 18,
    ),
    Event(
      id: 'ev-22',
      title: 'Campus 5K Charity Fun Run & Health Walk',
      category: 'Sports',
      dateTime: DateTime(2026, 12, 30, 09, 30),
      venue: 'Campus Green Park Trail',
      description:
          'A friendly non-competitive 5K loop around the green campus perimeter supporting local wildlife rescue shelters. Finisher medals and fruit provided.',
      imagePath: 'assets/images/marathon_run.jpg',
      totalCapacity: 250,
      availablePlaces: 140,
    ),

    // 5. New Career & Networking events
    Event(
      id: 'ev-23',
      title: 'Global Tech Companies Internship Fair',
      category: 'Career',
      dateTime: DateTime(2027, 1, 4, 10, 0),
      venue: 'ESTÜ Main Convention & Expo Center',
      description:
          'Meet corporate recruiters, senior tech leads, and HR managers from over 40 multinational companies offering paid summer engineering internships.',
      imagePath: 'assets/images/internship_fair.jpg',
      totalCapacity: 300,
      availablePlaces: 65,
    ),
    Event(
      id: 'ev-24',
      title: 'LinkedIn & Personal Brand Workshop',
      category: 'Career',
      dateTime: DateTime(2027, 1, 6, 14, 0),
      venue: 'Business Administration Seminar Hall',
      description:
          'Learn how to write high-impact professional summaries, showcase GitHub projects, and network effectively with international tech recruiters.',
      imagePath: 'assets/images/personal_branding.jpg',
      totalCapacity: 70,
      availablePlaces: 15,
    ),
    Event(
      id: 'ev-25',
      title: 'Campus Startup Pitch Battle & Angel Investors',
      category: 'Career',
      dateTime: DateTime(2027, 1, 8, 15, 30),
      venue: 'ESTÜ Technology Transfer Office (ARINKOM)',
      description:
          'Ten promising student startups deliver 5-minute pitches to venture capitalists and angel investors competing for 100,000 TL seed incubation grants.',
      imagePath: 'assets/images/startup_pitch.jpg',
      totalCapacity: 80,
      availablePlaces: 22,
    ),
    Event(
      id: 'ev-26',
      title: 'Mock Coding Interviews & Whiteboard Clinic',
      category: 'Career',
      dateTime: DateTime(2027, 1, 10, 13, 0),
      venue: 'Engineering Faculty Room 204',
      description:
          'Simulate grueling Big Tech technical interviews! Practice live data structures, algorithms, and system design problems with instant constructive feedback.',
      imagePath: 'assets/images/mock_interview.jpg',
      totalCapacity: 40,
      availablePlaces: 1, // Almost full
    ),

    // 6. New Academic & Research events
    Event(
      id: 'ev-27',
      title: 'ESTÜ Astronomy & Deep Sky Observation Night',
      category: 'Academic',
      dateTime: DateTime(2027, 1, 12, 20, 30),
      venue: 'Campus Observatory Hill & Telescope Deck',
      description:
          'Gaze at Jupiter moons, Saturn rings, and the Orion nebula through our high-powered campus telescopes alongside astrophysics professors. Hot cocoa included.',
      imagePath: 'assets/images/astronomy_sky.jpg',
      totalCapacity: 90,
      availablePlaces: 33,
    ),
    Event(
      id: 'ev-28',
      title: 'International Sustainable Energy Symposium',
      category: 'Academic',
      dateTime: DateTime(2027, 1, 15, 09, 30),
      venue: 'Environmental Sciences Central Auditorium',
      description:
          'Keynote presentations on solar photovoltaics, green hydrogen fuel cells, and microgrid engineering presented by international visiting researchers.',
      imagePath: 'assets/images/renewable_energy.jpg',
      totalCapacity: 140,
      availablePlaces: 52,
    ),
    Event(
      id: 'ev-29',
      title: 'Materials Science & Nanotechnology Colloquium',
      category: 'Academic',
      dateTime: DateTime(2027, 1, 18, 14, 0),
      venue: 'Nanotechnology Research Center (NANOTAM)',
      description:
          'Discover breakthrough research in carbon nanotubes, smart aerospace alloys, and biomedical polymers developed inside ESTÜ cleanroom facilities.',
      imagePath: 'assets/images/nanotechnology.jpg',
      totalCapacity: 65,
      availablePlaces: 19,
    ),
    Event(
      id: 'ev-30',
      title: 'University Debate Championship: AI & Ethics',
      category: 'Academic',
      dateTime: DateTime(2027, 1, 21, 16, 0),
      venue: 'Law & Ethics Amphitheater 1',
      description:
          'The ultimate battle of intellects! Two finalist student teams spar on philosophical, regulatory, and societal implications of autonomous artificial agents.',
      imagePath: 'assets/images/debate_championship.jpg',
      totalCapacity: 100,
      availablePlaces: 38,
    ),
  ];
}
