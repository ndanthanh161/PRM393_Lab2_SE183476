import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/analyzer_provider.dart';
import 'state/theme_provider.dart';
import 'screens/navigation_shell.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalyzerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ScholarFinder',
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
