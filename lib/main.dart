import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/openalex_service.dart';
import 'state/analyzer_provider.dart';
import 'state/theme_provider.dart';
import 'screens/navigation_shell.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final OpenAlexService? openAlexService;

  const MyApp({super.key, this.openAlexService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AnalyzerProvider(service: openAlexService),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Journal Trend Analyzer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.mode,
            home: const NavigationShell(),
          );
        },
      ),
    );
  }
}
