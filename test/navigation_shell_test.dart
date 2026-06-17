import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:journal_trend_analyzer/screens/navigation_shell.dart';
import 'package:journal_trend_analyzer/state/analyzer_provider.dart';
import 'package:journal_trend_analyzer/state/theme_provider.dart';
import 'package:journal_trend_analyzer/models/work_model.dart';
import 'package:journal_trend_analyzer/services/openalex_service.dart';

class MockOpenAlexService implements OpenAlexService {
  final List<Work> dummyWorks;
  final List<String> dummyTopicSuggestions;
  MockOpenAlexService(this.dummyWorks, {this.dummyTopicSuggestions = const []});

  @override
  Future<OpenAlexResponse> searchWorks(
    String query, {
    int page = 1,
    int perPage = 100,
  }) async {
    return OpenAlexResponse(works: dummyWorks, totalCount: dummyWorks.length);
  }

  @override
  Future<List<String>> fetchTopicSuggestions({int perPage = 6}) async {
    return dummyTopicSuggestions.take(perPage).toList();
  }
}

void main() {
  testWidgets('NavigationShell renders NavigationBar and responds to taps', (
    WidgetTester tester,
  ) async {
    final analyzerProvider = AnalyzerProvider(service: MockOpenAlexService([]));
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AnalyzerProvider>.value(
            value: analyzerProvider,
          ),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ],
        child: const MaterialApp(home: NavigationShell()),
      ),
    );

    // Verify NavigationBar is present
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify 3 destinations: Explore, Summary, Analytics
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);

    // Default tab should be Explore (index 0)
    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navigationBar.selectedIndex, 0);

    // Tap on Summary
    await tester.tap(find.text('Summary'));
    await tester.pumpAndSettle();

    // Verify tab changed
    final updatedNavigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(updatedNavigationBar.selectedIndex, 1);
  });

  testWidgets('NavigationShell shows/hides Badge based on hasResults', (
    WidgetTester tester,
  ) async {
    final dummyWorks = [
      Work(
        id: '1',
        title: 'Test Paper',
        publicationYear: 2022,
        citedByCount: 5,
        journalName: 'Test Journal',
        authors: ['Test Author'],
        abstractText: 'Test Abstract',
      ),
    ];
    final analyzerProvider = AnalyzerProvider(
      service: MockOpenAlexService(dummyWorks),
    );
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AnalyzerProvider>.value(
            value: analyzerProvider,
          ),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ],
        child: const MaterialApp(home: NavigationShell()),
      ),
    );

    // Initially, works is empty, so no badges should be visible.
    // In Flutter, Badge shows label/dot only if isLabelVisible is true.
    // Let's check that no active Badges are shown.
    var badges = tester.widgetList<Badge>(find.byType(Badge));
    for (var badge in badges) {
      expect(badge.isLabelVisible, isFalse);
    }

    // Trigger search to populate works
    await analyzerProvider.search('test');
    await tester.pumpAndSettle();

    // Now works is not empty. We are on Explore (index 0).
    // The Summary (index 1) and Analytics (index 2) destinations should show badges.
    badges = tester.widgetList<Badge>(find.byType(Badge));
    expect(badges.length, 2); // Badge on Summary, Badge on Analytics
    for (var badge in badges) {
      expect(badge.isLabelVisible, isTrue);
    }

    // Tap on Summary (index 1)
    await tester.tap(find.text('Summary'));
    await tester.pumpAndSettle();

    // Now we are on index 1, so:
    // - Summary badge should be hidden (isLabelVisible = false)
    // - Analytics badge should be visible (isLabelVisible = true)
    final summaryBadgeFinder = find.descendant(
      of: find.byType(NavigationDestination).at(1),
      matching: find.byType(Badge),
    );
    final analyticsBadgeFinder = find.descendant(
      of: find.byType(NavigationDestination).at(2),
      matching: find.byType(Badge),
    );

    expect(summaryBadgeFinder, findsNothing);
    expect(tester.widget<Badge>(analyticsBadgeFinder).isLabelVisible, isTrue);
  });
}
