import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';
import 'package:campus_event_explorer/widgets/event_card.dart';

void main() {
  testWidgets('App renders Explore tab and initial events', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Verify app bar title
    expect(find.text('Explore Campus Events'), findsOneWidget);

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
}
