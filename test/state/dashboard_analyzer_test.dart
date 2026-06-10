import 'package:flutter_test/flutter_test.dart';

import 'package:journal_trend_analyzer/models/publication.dart';
import 'package:journal_trend_analyzer/state/dashboard_analyzer.dart';

void main() {
  test('analyze computes core dashboard metrics', () {
    const publications = [
      Publication(
        id: 'W1',
        title: 'Paper 1',
        publicationYear: 2021,
        citationCount: 10,
        journalName: 'Journal A',
        authorNames: ['Alice', 'Bob'],
        doi: null,
        abstractText: null,
      ),
      Publication(
        id: 'W2',
        title: 'Paper 2',
        publicationYear: 2022,
        citationCount: 30,
        journalName: 'Journal A',
        authorNames: ['Alice'],
        doi: null,
        abstractText: null,
      ),
    ];

    final summary = DashboardAnalyzer.analyze(publications);

    expect(summary.totalPublications, 2);
    expect(summary.averageCitationCount, 20);
    expect(summary.mostActiveYear, 2021);
    expect(summary.topJournal, 'Journal A');
    expect(summary.topAuthor, 'Alice');
    expect(summary.mostInfluentialPaper?.title, 'Paper 2');
  });
}
