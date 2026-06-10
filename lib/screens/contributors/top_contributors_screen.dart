import 'package:flutter/material.dart';

import '../../models/author_summary.dart';
import '../../models/journal_summary.dart';

class TopContributorsScreen extends StatelessWidget {
  const TopContributorsScreen({
    super.key,
    required this.topic,
    required this.journals,
    required this.authors,
  });

  final String topic;
  final List<JournalSummary> journals;
  final List<AuthorSummary> authors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Journals & Authors')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topic',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    topic,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _RankingCard<JournalSummary>(
              title: 'Top Journals',
              emptyLabel: 'No journal ranking available.',
              items: journals,
              nameOf: (item) => item.name,
              countOf: (item) => item.publicationCount,
            ),
            const SizedBox(height: 12),
            _RankingCard<AuthorSummary>(
              title: 'Top Authors',
              emptyLabel: 'No author ranking available.',
              items: authors,
              nameOf: (item) => item.name,
              countOf: (item) => item.publicationCount,
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingCard<T> extends StatelessWidget {
  const _RankingCard({
    required this.title,
    required this.emptyLabel,
    required this.items,
    required this.nameOf,
    required this.countOf,
  });

  final String title;
  final String emptyLabel;
  final List<T> items;
  final String Function(T item) nameOf;
  final int Function(T item) countOf;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            Text(emptyLabel, style: Theme.of(context).textTheme.bodyMedium)
          else
            ...items.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '$rank. ${nameOf(item)} (${countOf(item)} papers)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }),
        ],
      ),
    );
  }
}
