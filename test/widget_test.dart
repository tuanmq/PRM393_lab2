import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:journal_trend_analyzer/app.dart';
import 'package:journal_trend_analyzer/models/publication.dart';
import 'package:journal_trend_analyzer/screens/search/search_screen.dart';
import 'package:journal_trend_analyzer/services/openalex_service.dart';
import 'package:journal_trend_analyzer/services/publication_repository.dart';
import 'package:journal_trend_analyzer/state/search_provider.dart';

void main() {
  testWidgets('slice 1 search screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const JournalTrendAnalyzerApp());

    expect(find.text('Journal Trend Analyzer'), findsOneWidget);
    expect(find.text('Search OpenAlex'), findsOneWidget);
    expect(
      find.text('Search a topic to start the first analysis slice.'),
      findsOneWidget,
    );
  });

  testWidgets('tapping a search result opens publication details', (
    WidgetTester tester,
  ) async {
    final provider = SearchProvider(repository: _FakePublicationRepository());

    await tester.pumpWidget(
      ChangeNotifierProvider<SearchProvider>.value(
        value: provider,
        child: const MaterialApp(home: SearchScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Artificial Intelligence');
    await tester.tap(find.text('Search OpenAlex'));
    await tester.pump();
    await tester.pump();

    expect(find.text('AI for Software Engineering'), findsOneWidget);

    await tester.tap(find.text('AI for Software Engineering'));
    await tester.pumpAndSettle();

    expect(find.text('Publication Details'), findsOneWidget);
    expect(find.text('Journal of Smart Systems'), findsOneWidget);
    expect(find.text('10.1000/xyz123'), findsOneWidget);
  });
}

class _FakePublicationRepository extends PublicationRepository {
  _FakePublicationRepository() : super(const OpenAlexService());

  @override
  Future<List<Publication>> searchByTopic(String topic) async {
    return const [
      Publication(
        id: 'W1',
        title: 'AI for Software Engineering',
        publicationYear: 2024,
        citationCount: 128,
        journalName: 'Journal of Smart Systems',
        authorNames: ['Alice Nguyen', 'Minh Tran'],
        doi: '10.1000/xyz123',
        abstractText: 'This paper studies how AI supports software teams.',
      ),
    ];
  }
}
