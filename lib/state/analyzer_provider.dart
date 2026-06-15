import 'package:flutter/foundation.dart';
import '../models/work_model.dart';
import '../services/openalex_service.dart';

class AnalyzerProvider with ChangeNotifier {
  final OpenAlexService _service;

  List<Work> _works = [];      // Publications on the current page
  List<Work> _allWorks = [];   // All loaded publications for trend/stats analysis
  bool _isLoading = false;
  bool _isBackgroundLoading = false;
  String? _error;
  String _currentQuery = '';
  int _currentPage = 1;
  int _totalCount = 0;
  static const int _perPage = 100;

  AnalyzerProvider({OpenAlexService? service})
      : _service = service ?? OpenAlexService();

  List<Work> get works => _works;
  List<Work> get allWorks => _allWorks;
  bool get isLoading => _isLoading;
  bool get isBackgroundLoading => _isBackgroundLoading;
  String? get error => _error;
  String get currentQuery => _currentQuery;
  int get currentPage => _currentPage;
  int get totalCount => _totalCount;
  int get totalPages => (_totalCount / _perPage).ceil();

  // --- Analytical Getters (using _allWorks for comprehensive stats) ---

  int get totalPublications => _allWorks.length;

  double get averageCitationCount {
    if (_allWorks.isEmpty) return 0.0;
    final totalCitations = _allWorks.fold<int>(0, (sum, item) => sum + item.citedByCount);
    return totalCitations / _allWorks.length;
  }

  int get mostActivePublicationYear {
    if (_allWorks.isEmpty) return 0;
    final counts = <int, int>{};
    for (var work in _allWorks) {
      if (work.publicationYear > 0) {
        counts[work.publicationYear] = (counts[work.publicationYear] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return 0;
    int bestYear = 0;
    int maxCount = -1;
    counts.forEach((year, count) {
      if (count > maxCount) {
        maxCount = count;
        bestYear = year;
      }
    });
    return bestYear;
  }

  String get topJournal {
    if (_allWorks.isEmpty) return 'N/A';
    final counts = <String, int>{};
    for (var work in _allWorks) {
      final name = work.journalName;
      if (name != 'Unknown Source') {
        counts[name] = (counts[name] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return 'N/A';
    String bestJournal = 'N/A';
    int maxCount = -1;
    counts.forEach((journal, count) {
      if (count > maxCount) {
        maxCount = count;
        bestJournal = journal;
      }
    });
    return bestJournal;
  }

  String get topAuthor {
    if (_allWorks.isEmpty) return 'N/A';
    final counts = <String, int>{};
    for (var work in _allWorks) {
      for (var author in work.authors) {
        counts[author] = (counts[author] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return 'N/A';
    String bestAuthor = 'N/A';
    int maxCount = -1;
    counts.forEach((author, count) {
      if (count > maxCount) {
        maxCount = count;
        bestAuthor = author;
      }
    });
    return bestAuthor;
  }

  Work? get mostInfluentialPaper {
    if (_allWorks.isEmpty) return null;
    Work? bestPaper;
    int maxCitations = -1;
    for (var work in _allWorks) {
      if (work.citedByCount > maxCitations) {
        maxCitations = work.citedByCount;
        bestPaper = work;
      }
    }
    return bestPaper;
  }

  /// Publications sorted from highest to lowest citation count.
  List<Work> get topInfluentialPapers {
    final sortedWorks = List<Work>.from(_allWorks)
      ..sort((a, b) => b.citedByCount.compareTo(a.citedByCount));
    return sortedWorks;
  }

  /// Publication trends by year, sorted chronologically.
  Map<int, int> get yearlyTrends {
    final Map<int, int> trends = {};
    for (var work in _allWorks) {
      if (work.publicationYear > 0) {
        trends[work.publicationYear] = (trends[work.publicationYear] ?? 0) + 1;
      }
    }
    // Return sorted by year (ascending)
    final sortedKeys = trends.keys.toList()..sort();
    return {for (var key in sortedKeys) key: trends[key]!};
  }

  /// Journals with the most publications, sorted descending.
  List<MapEntry<String, int>> get topJournals {
    final Map<String, int> counts = {};
    for (var work in _allWorks) {
      counts[work.journalName] = (counts[work.journalName] ?? 0) + 1;
    }
    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  /// Authors with the most publications, sorted descending.
  List<MapEntry<String, int>> get topAuthors {
    final Map<String, int> counts = {};
    for (var work in _allWorks) {
      for (var author in work.authors) {
        counts[author] = (counts[author] ?? 0) + 1;
      }
    }
    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  // --- Actions ---

  Future<void> search(String query) async {
    _isLoading = true;
    _isBackgroundLoading = false;
    _error = null;
    _currentQuery = query;
    _currentPage = 1;
    _works = [];
    _allWorks = [];
    _totalCount = 0;
    notifyListeners();

    try {
      final response = await _service.searchWorks(query, page: 1, perPage: _perPage);
      _works = response.works;
      _allWorks = List.from(response.works);
      _totalCount = response.totalCount;
    } catch (e) {
      _error = e.toString();
      _works = [];
      _allWorks = [];
      _totalCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Start background loading for subsequent pages (up to 20 pages / 2000 items)
    if (_totalCount > _perPage && _error == null) {
      _startBackgroundLoading(query);
    }
  }

  Future<void> _startBackgroundLoading(String query) async {
    _isBackgroundLoading = true;
    notifyListeners();

    try {
      final int maxPagesToFetch = ((_totalCount / _perPage).ceil()).clamp(1, 20);
      
      if (maxPagesToFetch > 1) {
        final futures = <Future<OpenAlexResponse>>[];
        for (int page = 2; page <= maxPagesToFetch; page++) {
          // AI Review: Break early if query changed or cleared
          if (_currentQuery != query || _currentQuery.isEmpty) break;
          futures.add(_service.searchWorks(query, page: page, perPage: _perPage));
        }

        if (futures.isNotEmpty) {
          final responses = await Future.wait(futures);

          if (_currentQuery == query) {
            final existingIds = _allWorks.map((w) => w.id).toSet();
            for (var response in responses) {
              // Double check if query changed mid-execution
              if (_currentQuery != query || _currentQuery.isEmpty) break;
              for (var work in response.works) {
                if (!existingIds.contains(work.id)) {
                  _allWorks.add(work);
                }
              }
            }

            final startIndex = (_currentPage - 1) * _perPage;
            if (_allWorks.length > startIndex) {
              final int endIndex = (_currentPage * _perPage).clamp(0, _allWorks.length);
              _works = _allWorks.sublist(startIndex, endIndex);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Background loading error: $e');
    } finally {
      _isBackgroundLoading = false;
      notifyListeners();
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > totalPages) return;
    
    _currentPage = page;
    final int startIndex = (page - 1) * _perPage;

    if (_allWorks.length > startIndex) {
      final int endIndex = (page * _perPage).clamp(0, _allWorks.length);
      _works = _allWorks.sublist(startIndex, endIndex);
      notifyListeners();

      // If we don't have the full page yet, and background loading is not active, load it explicitly.
      if (_works.length < _perPage && _allWorks.length < _totalCount && !_isBackgroundLoading) {
        await _fetchPageExplicitly(page);
      }
    } else {
      await _fetchPageExplicitly(page);
    }
  }

  Future<void> _fetchPageExplicitly(int page) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.searchWorks(_currentQuery, page: page, perPage: _perPage);
      _works = response.works;

      final existingIds = _allWorks.map((w) => w.id).toSet();
      for (var work in response.works) {
        if (!existingIds.contains(work.id)) {
          _allWorks.add(work);
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> nextPage() async {
    if (_currentPage < totalPages) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1);
    }
  }

  void clearSearch() {
    _works = [];
    _allWorks = [];
    _isLoading = false;
    _isBackgroundLoading = false;
    _error = null;
    _currentQuery = '';
    _currentPage = 1;
    _totalCount = 0;
    notifyListeners();
  }
}
