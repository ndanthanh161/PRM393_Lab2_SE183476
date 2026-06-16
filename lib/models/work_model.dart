class Work {
  final String id;
  final String title;
  final int publicationYear;
  final int citedByCount;
  final String? doi;
  final String journalName;
  final List<String> authors;
  final String abstractText;

  Work({
    required this.id,
    required this.title,
    required this.publicationYear,
    required this.citedByCount,
    this.doi,
    required this.journalName,
    required this.authors,
    required this.abstractText,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final title = json['title'] as String? ?? 'Untitled';
    final publicationYear = json['publication_year'] as int? ?? 0;
    final citedByCount = json['cited_by_count'] as int? ?? 0;
    final doi = json['doi'] as String?;

    String journalName = 'Unknown Source';
    final primaryLocation = json['primary_location'];
    if (primaryLocation != null && primaryLocation is Map) {
      final source = primaryLocation['source'];
      if (source != null && source is Map) {
        journalName = source['display_name'] as String? ?? 'Unknown Source';
      }
    }

    final authorsList = <String>[];
    final authorships = json['authorships'];
    if (authorships != null && authorships is List) {
      for (var auth in authorships) {
        if (auth is Map) {
          final authorObj = auth['author'];
          if (authorObj != null && authorObj is Map) {
            final name = authorObj['display_name'] as String?;
            if (name != null && name.isNotEmpty) {
              authorsList.add(name);
            }
          }
        }
      }
    }

    // Safely parse abstract_inverted_index if it exists
    final abstractIndex =
        json['abstract_inverted_index'] as Map<String, dynamic>?;
    final abstractText = _reconstructAbstract(abstractIndex);

    return Work(
      id: id,
      title: title,
      publicationYear: publicationYear,
      citedByCount: citedByCount,
      doi: doi,
      journalName: journalName,
      authors: authorsList,
      abstractText: abstractText,
    );
  }

  static String _reconstructAbstract(Map<String, dynamic>? invertedIndex) {
    if (invertedIndex == null || invertedIndex.isEmpty) {
      return 'No abstract available.';
    }

    int maxIndex = -1;
    invertedIndex.forEach((word, indices) {
      if (indices is List) {
        for (var idx in indices) {
          if (idx is int && idx > maxIndex) {
            maxIndex = idx;
          }
        }
      }
    });

    if (maxIndex < 0) {
      return 'No abstract available.';
    }

    final List<String> words = List.filled(maxIndex + 1, '');
    invertedIndex.forEach((word, indices) {
      if (indices is List) {
        for (var idx in indices) {
          if (idx is int && idx >= 0 && idx <= maxIndex) {
            words[idx] = word;
          }
        }
      }
    });

    return words.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
