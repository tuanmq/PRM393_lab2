import '../models/author_summary.dart';
import '../models/journal_summary.dart';
import '../models/publication.dart';

class ContributorsResult {
  const ContributorsResult({
    required this.topJournals,
    required this.topAuthors,
  });

  final List<JournalSummary> topJournals;
  final List<AuthorSummary> topAuthors;
}

class ContributorsAnalyzer {
  const ContributorsAnalyzer._();

  static ContributorsResult analyze(
    List<Publication> publications, {
    int limit = 10,
  }) {
    final journalCounts = <String, int>{};
    final authorCounts = <String, int>{};

    for (final publication in publications) {
      final journal = publication.journalName.trim();
      if (journal.isNotEmpty && journal != 'Unknown journal') {
        journalCounts[journal] = (journalCounts[journal] ?? 0) + 1;
      }

      for (final author in publication.authorNames) {
        final normalized = author.trim();
        if (normalized.isEmpty) {
          continue;
        }
        authorCounts[normalized] = (authorCounts[normalized] ?? 0) + 1;
      }
    }

    final journals =
        journalCounts.entries
            .map(
              (entry) => JournalSummary(
                name: entry.key,
                publicationCount: entry.value,
              ),
            )
            .toList(growable: false)
          ..sort((left, right) {
            final byCount = right.publicationCount.compareTo(
              left.publicationCount,
            );
            if (byCount != 0) {
              return byCount;
            }
            return left.name.compareTo(right.name);
          });

    final authors =
        authorCounts.entries
            .map(
              (entry) =>
                  AuthorSummary(name: entry.key, publicationCount: entry.value),
            )
            .toList(growable: false)
          ..sort((left, right) {
            final byCount = right.publicationCount.compareTo(
              left.publicationCount,
            );
            if (byCount != 0) {
              return byCount;
            }
            return left.name.compareTo(right.name);
          });

    return ContributorsResult(
      topJournals: journals.take(limit).toList(growable: false),
      topAuthors: authors.take(limit).toList(growable: false),
    );
  }
}
