import '../models/publication.dart';
import 'openalex_service.dart';

class PublicationRepository {
  const PublicationRepository(this._service);

  final OpenAlexService _service;

  Future<List<Publication>> searchByTopic(String topic) {
    return _service.searchPublications(topic);
  }
}
