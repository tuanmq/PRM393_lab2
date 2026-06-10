import 'publication.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalPublications,
    required this.averageCitationCount,
    required this.mostActiveYear,
    required this.topJournal,
    required this.topAuthor,
    required this.mostInfluentialPaper,
  });

  final int totalPublications;
  final double averageCitationCount;
  final int? mostActiveYear;
  final String? topJournal;
  final String? topAuthor;
  final Publication? mostInfluentialPaper;
}
