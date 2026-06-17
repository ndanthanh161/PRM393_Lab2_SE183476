import 'package:flutter_test/flutter_test.dart';
import 'package:journal_trend_analyzer/models/work_model.dart';
import 'package:journal_trend_analyzer/services/openalex_service.dart';
import 'package:journal_trend_analyzer/state/analyzer_provider.dart';

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
  group('AnalyzerProvider Tests', () {
    late List<Work> dummyWorks;

    setUp(() {
      dummyWorks = [
        Work(
          id: '1',
          title: 'Paper 1',
          publicationYear: 2020,
          citedByCount: 10,
          journalName: 'Journal A',
          authors: ['Author A', 'Author B'],
          abstractText: 'Abstract 1',
        ),
        Work(
          id: '2',
          title: 'Paper 2',
          publicationYear: 2020,
          citedByCount: 50,
          journalName: 'Journal B',
          authors: ['Author B', 'Author C'],
          abstractText: 'Abstract 2',
        ),
        Work(
          id: '3',
          title: 'Paper 3',
          publicationYear: 2021,
          citedByCount: 30,
          journalName: 'Journal A',
          authors: ['Author B'],
          abstractText: 'Abstract 3',
        ),
      ];
    });

    test('Initial state is empty', () {
      final provider = AnalyzerProvider();
      expect(provider.works, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.totalPublications, 0);
      expect(provider.averageCitationCount, 0.0);
    });

    test('Computes stats correctly after search', () async {
      final mockService = MockOpenAlexService(dummyWorks);
      final provider = AnalyzerProvider(service: mockService);

      await provider.search('test');

      expect(provider.works.length, 3);
      expect(provider.totalPublications, 3);

      // (10 + 50 + 30) / 3 = 30.0
      expect(provider.averageCitationCount, 30.0);

      // 2020 has 2 papers, 2021 has 1 paper
      expect(provider.mostActivePublicationYear, 2020);

      // Journal A has 2 papers, Journal B has 1 paper
      expect(provider.topJournal, 'Journal A');

      // Author B appears in all 3 papers, others appear once
      expect(provider.topAuthor, 'Author B');

      // Paper 2 has 50 citations
      expect(provider.mostInfluentialPaper?.id, '2');

      // Influential papers are ranked by citation count, highest first
      expect(provider.topInfluentialPapers.map((work) => work.id), [
        '2',
        '3',
        '1',
      ]);

      // Yearly trends sorted ascending: {2020: 2, 2021: 1}
      expect(provider.yearlyTrends, {2020: 2, 2021: 1});

      // Top journals sorted descending: Journal A (2), Journal B (1)
      expect(provider.topJournals[0].key, 'Journal A');
      expect(provider.topJournals[0].value, 2);
      expect(provider.topJournals[1].key, 'Journal B');
      expect(provider.topJournals[1].value, 1);

      // Top authors sorted descending: Author B (3), others (1)
      expect(provider.topAuthors[0].key, 'Author B');
      expect(provider.topAuthors[0].value, 3);
    });

    test('Loads topic suggestions from OpenAlex service', () async {
      final mockService = MockOpenAlexService(
        dummyWorks,
        dummyTopicSuggestions: ['Medicine', 'Computer Science'],
      );
      final provider = AnalyzerProvider(service: mockService);

      await provider.loadTopicSuggestions();

      expect(provider.topicSuggestions, ['Medicine', 'Computer Science']);
      expect(provider.isLoadingTopicSuggestions, isFalse);
      expect(provider.topicSuggestionsError, isNull);
    });
  });
}
