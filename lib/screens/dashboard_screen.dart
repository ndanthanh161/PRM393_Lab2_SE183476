import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/work_model.dart';
import '../state/analyzer_provider.dart';
import '../widgets/metric_tag.dart';
import '../widgets/theme_toggle_button.dart';
import 'detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToSearch;

  const DashboardScreen({super.key, required this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();
    final hasData = provider.works.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: !hasData
          ? _buildEmptyState(context)
          : _buildDashboard(context, provider),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dataset_outlined,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No Dataset Available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Search for a topic to generate a research summary.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onNavigateToSearch,
              icon: const Icon(Icons.search_rounded, size: 16),
              label: const Text('Explore'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AnalyzerProvider provider) {
    final influentialPaper = provider.mostInfluentialPaper;
    final topInfluentialPapers = provider.topInfluentialPapers.take(5).toList();
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Key Performance Indicators'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Publications',
                  value: provider.totalPublications.toString(),
                  icon: Icons.article_outlined,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Avg. citations',
                  value: provider.averageCitationCount.toStringAsFixed(1),
                  icon: Icons.format_quote_rounded,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Peak year',
                  value: provider.mostActivePublicationYear.toString(),
                  icon: Icons.event_rounded,
                  color: colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Top journal',
                  value: provider.topJournal,
                  icon: Icons.menu_book_outlined,
                  color: const Color(0xFFF59E0B),
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Most Active Researcher'),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.person_search_outlined,
            label: 'Author',
            value: provider.topAuthor,
            color: colorScheme.primary,
          ),
          if (influentialPaper != null) ...[
            const SizedBox(height: 20),
            const _SectionTitle(title: 'Most Influential Publication'),
            const SizedBox(height: 12),
            _InfluentialPaperCard(work: influentialPaper),
          ],
          if (topInfluentialPapers.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _SectionTitle(title: 'Top Influential Papers'),
            const SizedBox(height: 12),
            _InfluentialPaperRankedList(works: topInfluentialPapers),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfluentialPaperCard extends StatelessWidget {
  final Work work;

  const _InfluentialPaperCard({required this.work});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 280),
              pageBuilder: (_, _, _) => DetailScreen(work: work),
              transitionsBuilder: (_, anim, _, child) =>
                  FadeTransition(opacity: anim, child: child),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CountPill(
                    label: '${work.citedByCount} citations',
                    color: colorScheme.error,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                work.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                work.journalName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfluentialPaperRankedList extends StatelessWidget {
  final List<Work> works;

  const _InfluentialPaperRankedList({required this.works});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
        ),
      ),
      child: Column(
        children: works.asMap().entries.map((indexed) {
          final index = indexed.key;
          final work = indexed.value;
          final isLast = index == works.length - 1;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 280),
                  pageBuilder: (_, _, _) => DetailScreen(work: work),
                  transitionsBuilder: (_, anim, _, child) =>
                      FadeTransition(opacity: anim, child: child),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: index == 0
                            ? colorScheme.error
                            : colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          work.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${work.publicationYear} - ${work.journalName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CountPill(
                    label: '${work.citedByCount} citations',
                    color: colorScheme.error,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool compact;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.08 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.4)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Icon(
                Icons.trending_up_rounded,
                color: color.withValues(alpha: 0.35),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: compact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact && value.length > 12 ? 16 : 32,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
