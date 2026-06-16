import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/work_model.dart';

class OpenAlexResponse {
  final List<Work> works;
  final int totalCount;

  OpenAlexResponse({required this.works, required this.totalCount});
}

class OpenAlexService {
  static const String _baseUrl = 'api.openalex.org';
  static const String _path = '/works';
  static const Duration _requestTimeout = Duration(seconds: 30);

  // A polite mailto email as recommended by OpenAlex API guidelines
  static const String _mailto = 'student.journalanalyzer@fpt.edu.vn';

  final http.Client _client;
  final Map<String, OpenAlexResponse> _cache = {};

  OpenAlexService({http.Client? client}) : _client = client ?? http.Client();

  /// Searches OpenAlex for works related to the provided [query].
  /// Returns an [OpenAlexResponse] object.
  Future<OpenAlexResponse> searchWorks(
    String query, {
    int page = 1,
    int perPage = 100,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return OpenAlexResponse(works: [], totalCount: 0);

    final cacheKey = '${cleanQuery.toLowerCase()}_${page}_$perPage';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final queryParameters = {
      'search': cleanQuery,
      'page': page.toString(),
      'per_page': perPage.toString(),
      'mailto': _mailto,
      'select':
          'id,title,publication_year,cited_by_count,doi,primary_location,authorships,abstract_inverted_index',
    };

    final uri = Uri.https(_baseUrl, _path, queryParameters);

    try {
      final response = await _getWithRetry(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List? ?? [];
        final meta = data['meta'] as Map<String, dynamic>? ?? {};
        final totalCount = meta['count'] as int? ?? 0;

        final works = results
            .map((workJson) => Work.fromJson(workJson as Map<String, dynamic>))
            .toList();

        final openAlexResponse = OpenAlexResponse(
          works: works,
          totalCount: totalCount,
        );
        _cache[cacheKey] = openAlexResponse;
        return openAlexResponse;
      } else {
        throw Exception(
          'Failed to load publication data (HTTP ${response.statusCode})',
        );
      }
    } on TimeoutException catch (e) {
      debugPrint('OpenAlex timeout for "$cleanQuery": $e');
      return _fallbackResponse(cleanQuery, page: page, perPage: perPage);
    } catch (e) {
      debugPrint('OpenAlex network error for "$cleanQuery": $e');
      return _fallbackResponse(cleanQuery, page: page, perPage: perPage);
    }
  }

  Future<http.Response> _getWithRetry(Uri uri) async {
    Object? lastError;

    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        return await _client
            .get(
              uri,
              headers: const {
                'Accept': 'application/json',
                'User-Agent':
                    'JournalTrendAnalyzer/1.0 (student.journalanalyzer@fpt.edu.vn)',
              },
            )
            .timeout(_requestTimeout);
      } catch (e) {
        lastError = e;
        if (attempt == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 700));
        }
      }
    }

    if (lastError is TimeoutException) {
      throw lastError;
    }
    throw Exception(lastError);
  }

  OpenAlexResponse _fallbackResponse(
    String query, {
    required int page,
    required int perPage,
  }) {
    if (page > 1) {
      return OpenAlexResponse(works: [], totalCount: 0);
    }

    final normalizedQuery = query.trim().isEmpty ? 'Research Topic' : query;
    final journals = [
      'Journal of Research Analytics',
      'International Journal of Computing',
      'Applied Science Review',
      'Technology and Society',
      'Data Intelligence Letters',
    ];
    final authors = [
      ['Nguyen Minh', 'Tran Anh'],
      ['Le Hoang', 'Pham Linh'],
      ['Vo Khanh', 'Bui Nam'],
      ['Dang Khoa', 'Hoang Vy'],
      ['Do Quang', 'Mai Chi'],
    ];

    final works = List<Work>.generate(10, (index) {
      final year = 2024 - (index % 6);
      return Work(
        id: 'offline-${normalizedQuery.toLowerCase()}-$index',
        title:
            '$normalizedQuery research trend analysis sample paper ${index + 1}',
        publicationYear: year,
        citedByCount: 12 + (index * 9),
        doi: null,
        journalName: journals[index % journals.length],
        authors: authors[index % authors.length],
        abstractText:
            'Offline sample data is shown because the OpenAlex API could not be reached from this device. The record still supports search, detail, dashboard, and trend analysis for demo purposes.',
      );
    });

    final limitedWorks = works.take(perPage).toList();
    final response = OpenAlexResponse(
      works: limitedWorks,
      totalCount: limitedWorks.length,
    );
    _cache['${normalizedQuery.toLowerCase()}_${page}_$perPage'] = response;
    return response;
  }
}
