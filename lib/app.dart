import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/search/search_screen.dart';
import 'services/openalex_service.dart';
import 'services/publication_repository.dart';
import 'state/search_provider.dart';

class JournalTrendAnalyzerApp extends StatelessWidget {
  const JournalTrendAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => const OpenAlexService()),
        ProxyProvider<OpenAlexService, PublicationRepository>(
          update: (_, service, previousRepository) =>
              PublicationRepository(service),
        ),
        ChangeNotifierProxyProvider<PublicationRepository, SearchProvider>(
          create: (_) => SearchProvider(),
          update: (_, repository, provider) {
            final searchProvider = provider ?? SearchProvider();
            searchProvider.repository = repository;
            return searchProvider;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Journal Trend Analyzer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0E7490),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF3F7F8),
          useMaterial3: true,
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
