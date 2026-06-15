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
        title: const Text('Research Overview'),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: !hasData ? _buildEmptyState(context) : _buildDashboard(context, provider),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.space_dashboard_outlined,
                  color: colorScheme.primary.withOpacity(0.5), size: 40),
            ),
            const SizedBox(height: 18),
            Text(
              'No Data Yet',
              style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Search a research topic to see your overview here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onNavigateToSearch,
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: const Text('Discover'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero Stats Card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [colorScheme.primary.withOpacity(0.15), colorScheme.surface]
                    : [colorScheme.primary.withOpacity(0.08), colorScheme.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withOpacity(isDark ? 0.3 : 0.15),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _HeroStat(
                        value: provider.totalPublications.toString(),
                        label: 'Papers',
                        icon: Icons.description_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    Container(
                      width: 1, height: 50,
                      color: colorScheme.outline.withOpacity(0.15),
                    ),
                    Expanded(
                      child: _HeroStat(
                        value: provider.averageCitationCount.toStringAsFixed(1),
                        label: 'Avg. Cited',
                        icon: Icons.format_quote_rounded,
                        color: colorScheme.secondary,
                      ),
                    ),
                    Container(
                      width: 1, height: 50,
                      color: colorScheme.outline.withOpacity(0.15),
                    ),
                    Expanded(
                      child: _HeroStat(
                        value: provider.mostActivePublicationYear.toString(),
                        label: 'Peak Year',
                        icon: Icons.calendar_today_rounded,
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Top Journal & Researcher ──
          _SectionLabel(title: 'Key Highlights'),
          const SizedBox(height: 10),
          _HighlightTile(
            icon: Icons.menu_book_rounded,
            title: 'Top Journal',
            value: provider.topJournal,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          _HighlightTile(
            icon: Icons.person_rounded,
            title: 'Most Active Author',
            value: provider.topAuthor,
            color: colorScheme.secondary,
          ),

          if (influentialPaper != null) ...[
            const SizedBox(height: 20),
            _SectionLabel(title: 'Most Cited Paper'),
            const SizedBox(height: 10),
            _FeaturedPaperCard(work: influentialPaper),
          ],

          if (topInfluentialPapers.isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionLabel(title: 'Top Papers by Citations'),
            const SizedBox(height: 10),
            ...topInfluentialPapers.asMap().entries.map((indexed) {
              return _RankedPaperTile(
                rank: indexed.key + 1,
                work: indexed.value,
                isLast: indexed.key == topInfluentialPapers.length - 1,
              );
            }),
          ],
        ],
      ),
    );
  }
}

// ─── Hero Stat ───
class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _HeroStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ─── Highlight Tile ───
class _HighlightTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _HighlightTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(isDark ? 0.3 : 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant, fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700,
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

// ─── Featured Paper Card ───
class _FeaturedPaperCard extends StatelessWidget {
  final Work work;

  const _FeaturedPaperCard({required this.work});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.primary.withOpacity(isDark ? 0.35 : 0.2),
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
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '🏆 ${work.citedByCount} citations',
                      style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: colorScheme.onSurfaceVariant, size: 14),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                work.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface, height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                work.journalName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant, fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ranked Paper Tile ───
class _RankedPaperTile extends StatelessWidget {
  final int rank;
  final Work work;
  final bool isLast;

  const _RankedPaperTile({
    required this.rank,
    required this.work,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(isDark ? 0.25 : 0.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: rank == 1
                      ? colorScheme.primary.withOpacity(0.12)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: rank == 1 ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 13, fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${work.publicationYear} · ${work.journalName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant, fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MetricTag(
                text: '${work.citedByCount}',
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ───
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
