import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_trend_analyzer/main.dart';
import 'package:journal_trend_analyzer/services/openalex_service.dart';

class MockOpenAlexService implements OpenAlexService {
  @override
  Future<OpenAlexResponse> searchWorks(
    String query, {
    int page = 1,
    int perPage = 100,
  }) async {
    return OpenAlexResponse(works: [], totalCount: 0);
  }

  @override
  Future<List<String>> fetchTopicSuggestions({int perPage = 6}) async {
    return ['Medicine', 'Computer Science'].take(perPage).toList();
  }
}

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(openAlexService: MockOpenAlexService()));
    await tester.pump();

    // Verify that the search input is present.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the query section is visible.
    expect(find.text('Research Query'), findsOneWidget);
    expect(find.text('Medicine'), findsOneWidget);

    // Verify that the empty state instruction is visible.
    expect(find.text('Explore Research'), findsOneWidget);
  });
}
