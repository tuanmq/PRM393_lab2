import '../models/dashboard_summary.dart';
import '../models/publication.dart';
import 'contributors_analyzer.dart';
import 'influential_analyzer.dart';
import 'trend_analyzer.dart';

class DashboardAnalyzer {
  const DashboardAnalyzer._();

  static DashboardSummary analyze(List<Publication> publications) {
    final total = publications.length;
    final totalCitations = publications.fold<int>(
      0,
      (sum, publication) => sum + publication.citationCount,
    );
    final average = total == 0 ? 0.0 : totalCitations / total;

    final trend = TrendAnalyzer.analyze(publications);
    final contributors = ContributorsAnalyzer.analyze(publications, limit: 1);
    final influential = InfluentialAnalyzer.topPapers(publications, limit: 1);

    return DashboardSummary(
      totalPublications: total,
      averageCitationCount: average,
      mostActiveYear: trend.mostActiveYear,
      topJournal: contributors.topJournals.isEmpty
          ? null
          : contributors.topJournals.first.name,
      topAuthor: contributors.topAuthors.isEmpty
          ? null
          : contributors.topAuthors.first.name,
      mostInfluentialPaper: influential.isEmpty ? null : influential.first,
    );
  }
}
