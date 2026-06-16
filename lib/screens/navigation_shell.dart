import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/analyzer_provider.dart';
import 'search_screen.dart';
import 'dashboard_screen.dart';
import 'trend_screen.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const SearchScreen(),
      DashboardScreen(onNavigateToSearch: _navigateToSearch),
      TrendScreen(onNavigateToSearch: _navigateToSearch),
    ]);
  }

  void _navigateToSearch() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();
    final hasResults = provider.works.isNotEmpty;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: hasResults && _currentIndex != 1,
              child: const Icon(Icons.dataset_outlined),
            ),
            selectedIcon: const Icon(Icons.dataset_rounded),
            label: 'Summary',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: hasResults && _currentIndex != 2,
              child: const Icon(Icons.query_stats_outlined),
            ),
            selectedIcon: const Icon(Icons.query_stats_rounded),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
