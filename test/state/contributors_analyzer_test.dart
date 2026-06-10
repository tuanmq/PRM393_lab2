import 'package:flutter_test/flutter_test.dart';

import 'package:journal_trend_analyzer/models/publication.dart';
import 'package:journal_trend_analyzer/state/contributors_analyzer.dart';

void main() {
  test('analyze ranks journals and authors by publication count', () {
    const publications = [
      Publication(
        id: 'W1',
        title: 'P1',
        publicationYear: 2022,
        citationCount: 10,
        journalName: 'Journal A',
        authorNames: ['Alice', 'Bob'],
        doi: null,
        abstractText: null,
      ),
      Publication(
        id: 'W2',
        title: 'P2',
        publicationYear: 2023,
        citationCount: 8,
        journalName: 'Journal B',
        authorNames: ['Alice'],
        doi: null,
        abstractText: null,
      ),
      Publication(
        id: 'W3',
        title: 'P3',
        publicationYear: 2023,
        citationCount: 5,
        journalName: 'Journal A',
        authorNames: ['Charlie', 'Bob'],
        doi: null,
        abstractText: null,
      ),
    ];

    final result = ContributorsAnalyzer.analyze(publications, limit: 5);

    expect(result.topJournals.first.name, 'Journal A');
    expect(result.topJournals.first.publicationCount, 2);
    expect(result.topAuthors.first.name, 'Alice');
    expect(result.topAuthors.first.publicationCount, 2);
    expect(result.topAuthors[1].name, 'Bob');
    expect(result.topAuthors[1].publicationCount, 2);
  });
}
