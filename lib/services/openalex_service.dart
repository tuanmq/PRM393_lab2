import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../core/utils/app_error.dart';
import '../models/publication.dart';

class OpenAlexService {
  const OpenAlexService({http.Client? client}) : _client = client;

  final http.Client? _client;

  Future<List<Publication>> searchPublications(String topic) async {
    final normalizedTopic = topic.trim();
    if (normalizedTopic.isEmpty) {
      throw const AppError('Please enter a research topic.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}/works').replace(
      queryParameters: {
        'search': normalizedTopic,
        'per-page': '${ApiConstants.defaultPageSize}',
      },
    );

    final client = _client ?? http.Client();
    final shouldCloseClient = _client == null;

    try {
      final response = await client.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw AppError(
          'OpenAlex request failed with status ${response.statusCode}.',
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['results'] as List<dynamic>? ?? const [];

      return results
          .whereType<Map<String, dynamic>>()
          .map(Publication.fromOpenAlex)
          .toList(growable: false);
    } catch (error) {
      if (error is AppError) {
        rethrow;
      }
      throw AppError('Unable to load publications. Check your connection.');
    } finally {
      if (shouldCloseClient) {
        client.close();
      }
    }
  }
}
