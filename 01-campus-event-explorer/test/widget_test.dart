import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';
import 'package:campus_event_explorer/widgets/event_card.dart';
import 'package:campus_event_explorer/screens/image_viewer_screen.dart';

void main() {
  testWidgets('App renders Explore tab and initial events', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Verify app bar title
    expect(find.text('Explore Campus'), findsOneWidget);

    // Verify bottom navigation destinations
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('My Events'), findsOneWidget);

    // Verify event cards exist
    expect(find.byType(EventCard), findsWidgets);
    expect(find.text('Campus Hackathon 2026'), findsOneWidget);
  });

  testWidgets('Search query filters events and handles empty search results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Find the search input
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Search for "hackathon" with surrounding whitespace and different casing
    await tester.enterText(searchField, '   hAcKaThOn   ');
    await tester.pumpAndSettle();

    // Verify only the hackathon is shown (1 matching)
    expect(find.text('Campus Hackathon 2026'), findsOneWidget);
    expect(find.text('1 event matching'), findsOneWidget);
    expect(find.text('Autumn Contemporary Art Exhibition'), findsNothing);

    // Now search for non-existent event
    await tester.enterText(searchField, 'NonExistentEventXYZ');
    await tester.pumpAndSettle();

    // Verify empty state message and reset button
    expect(find.text('No Matching Events'), findsOneWidget);
    expect(find.text('Clear Search & Filters'), findsOneWidget);

    // Tap reset button
    await tester.tap(find.text('Clear Search & Filters'));
    await tester.pumpAndSettle();

    // Verify events are restored
    expect(find.text('Campus Hackathon 2026'), findsOneWidget);
  });

  testWidgets('Switching tabs shows appropriate empty states', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Tap Favorites tab
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No Favorites Yet'), findsOneWidget);

    // Tap My Events tab
    await tester.tap(find.text('My Events'));
    await tester.pumpAndSettle();
    expect(find.text('No Joined Events'), findsOneWidget);
  });

  testWidgets('Category filter chips filter events correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Tap on Technology filter chip by Key
    await tester.tap(find.byKey(const Key('filter-chip-Technology')));
    await tester.pumpAndSettle();

    expect(find.text('Campus Hackathon 2026'), findsOneWidget);
    expect(find.text('Autumn Contemporary Art Exhibition'), findsNothing);

    // Tap on Arts filter chip by Key
    await tester.tap(find.byKey(const Key('filter-chip-Arts')));
    await tester.pumpAndSettle();

    expect(find.text('Autumn Contemporary Art Exhibition'), findsOneWidget);
    expect(find.text('Campus Hackathon 2026'), findsNothing);

    // Tap on All to reset
    await tester.tap(find.byKey(const Key('filter-chip-All')));
    await tester.pumpAndSettle();

    expect(find.text('Campus Hackathon 2026'), findsOneWidget);
    expect(find.byType(EventCard), findsWidgets);
  });

  testWidgets('Join and cancel event participation flow', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Tap on the first event card to view details
    await tester.tap(find.byKey(const Key('event-card-ev-1')));
    await tester.pumpAndSettle();

    // Details screen is shown
    expect(find.text('Event Details'), findsOneWidget);
    expect(find.text('Join Event'), findsOneWidget);

    // Tap Join Event
    await tester.tap(find.text('Join Event'));
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Confirm Participation'), findsOneWidget);
    expect(find.text('Are you sure you want to join this event?'), findsOneWidget);

    // Confirm participation
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    // Now button should say Cancel Participation
    expect(find.text('Cancel Participation'), findsOneWidget);

    // Go back to Home
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Go to My Events tab
    await tester.tap(find.text('My Events'));
    await tester.pumpAndSettle();

    // Event should be listed in My Events with match counter
    expect(find.text('Campus Hackathon 2026'), findsOneWidget);
    expect(find.text('1 event matching'), findsOneWidget);

    // Open details again from My Events
    await tester.tap(find.byKey(const Key('event-card-ev-1')));
    await tester.pumpAndSettle();

    // Tap Cancel Participation
    await tester.tap(find.text('Cancel Participation'));
    await tester.pumpAndSettle();

    // Verify cancellation dialog
    expect(find.text('Cancel Participation'), findsWidgets);
    expect(find.text('Are you sure you want to cancel your participation?'), findsOneWidget);

    // Confirm cancel
    await tester.tap(find.text('Yes, Cancel'));
    await tester.pumpAndSettle();

    // Button should now be Join Event again
    expect(find.text('Join Event'), findsOneWidget);

    // Go back to Home
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Now My Events is empty
    expect(find.text('No Joined Events'), findsOneWidget);
  });

  testWidgets('Double-tap image opens ImageViewerScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Open first event
    await tester.tap(find.byKey(const Key('event-card-ev-1')));
    await tester.pumpAndSettle();

    // Double tap the image via gesture detector
    final gestureFinder = find.byKey(const Key('details-image-gesture'));
    expect(gestureFinder, findsOneWidget);
    await tester.tap(gestureFinder);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(gestureFinder);
    await tester.pumpAndSettle();

    // ImageViewerScreen is opened
    expect(find.byType(ImageViewerScreen), findsOneWidget);

    // Back button pops back
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(ImageViewerScreen), findsNothing);
  });

  testWidgets('Theme toggle switches mode', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Tap theme toggle button
    final themeToggle = find.byTooltip('Switch to Dark Mode');
    expect(themeToggle, findsOneWidget);
    await tester.tap(themeToggle);
    await tester.pumpAndSettle();

    // Should now show Switch to Light Mode tooltip
    expect(find.byTooltip('Switch to Light Mode'), findsOneWidget);
  });

  testWidgets('Event sorting bottom sheet opens and sorts events',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Verify sort button is present
    final sortButton = find.byKey(const Key('sort-button'));
    expect(sortButton, findsOneWidget);

    // Tap sort button to open bottom sheet
    await tester.tap(sortButton);
    await tester.pumpAndSettle();

    // Verify sort bottom sheet contents
    expect(find.text('Sort Events By'), findsOneWidget);
    expect(find.text('Upcoming Date'), findsOneWidget);
    expect(find.text('Alphabetical (A - Z)'), findsOneWidget);
    expect(find.text('Most Spots Left'), findsOneWidget);
    expect(find.text('Most Popular'), findsOneWidget);

    // Select Alphabetical sort
    await tester.tap(find.text('Alphabetical (A - Z)'));
    await tester.pumpAndSettle();

    // Verify event card list is present
    expect(find.byType(EventCard), findsWidgets);
    // AI & Machine Learning should be visible in alphabetical sort
    expect(find.text('AI & Machine Learning Hands-on Workshop'), findsOneWidget);
  });
}

