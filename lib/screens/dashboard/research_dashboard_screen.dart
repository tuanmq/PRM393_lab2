import 'package:flutter/material.dart';

import '../../models/publication.dart';
import '../../state/dashboard_analyzer.dart';
import '../detail/publication_detail_screen.dart';

class ResearchDashboardScreen extends StatelessWidget {
  const ResearchDashboardScreen({
    super.key,
    required this.topic,
    required this.publications,
  });

  final String topic;
  final List<Publication> publications;

  Future<void> _openDetail(BuildContext context, Publication publication) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PublicationDetailScreen(publication: publication),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = DashboardAnalyzer.analyze(publications);

    return Scaffold(
      appBar: AppBar(title: const Text('Research Dashboard')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF164E63), Color(0xFF0F766E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Topic',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    topic,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricTile(
                  title: 'Total Publications',
                  value: '${summary.totalPublications}',
                ),
                _MetricTile(
                  title: 'Average Citations',
                  value: summary.averageCitationCount.toStringAsFixed(1),
                ),
                _MetricTile(
                  title: 'Most Active Year',
                  value: summary.mostActiveYear?.toString() ?? 'N/A',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InsightCard(
              title: 'Top Journal',
              content: summary.topJournal ?? 'No journal insight available.',
            ),
            const SizedBox(height: 10),
            _InsightCard(
              title: 'Top Author',
              content: summary.topAuthor ?? 'No author insight available.',
            ),
            const SizedBox(height: 10),
            _InsightCard(
              title: 'Most Influential Paper',
              content: summary.mostInfluentialPaper == null
                  ? 'No influential paper identified.'
                  : summary.mostInfluentialPaper!.title,
              trailing: summary.mostInfluentialPaper == null
                  ? null
                  : TextButton.icon(
                      onPressed: () =>
                          _openDetail(context, summary.mostInfluentialPaper!),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('View Details'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.content,
    this.trailing,
  });

  final String title;
  final String content;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            ).textTheme.labelLarge?.copyWith(color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyLarge),
          if (trailing != null) ...[const SizedBox(height: 8), trailing!],
        ],
      ),
    );
  }
}
