import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../state/analyzer_provider.dart';
import '../widgets/theme_toggle_button.dart';

class TrendScreen extends StatelessWidget {
  final VoidCallback onNavigateToSearch;

  const TrendScreen({super.key, required this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();
    final hasData = provider.works.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Insights'),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: !hasData
          ? _buildEmptyState(context)
          : _buildTrends(context, provider),
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
              child: Icon(Icons.insights_rounded,
                  color: colorScheme.primary.withOpacity(0.5), size: 40),
            ),
            const SizedBox(height: 18),
            Text(
              'No Insights Yet',
              style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Search a topic to discover publication trends and patterns.',
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

  Widget _buildTrends(BuildContext context, AnalyzerProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.isBackgroundLoading) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Loading more data (${provider.allWorks.length} / ${provider.totalCount})...',
                      style: TextStyle(
                        fontSize: 12, color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Quick Stats Row ──
          _QuickStatsRow(provider: provider),
          const SizedBox(height: 22),

          // ── Publication Timeline ──
          _SectionHeader(
            title: 'Publication Timeline',
            subtitle: 'Number of papers published each year',
            icon: Icons.show_chart_rounded,
          ),
          const SizedBox(height: 12),
          _buildChart(context, provider),
          const SizedBox(height: 22),

          // ── Top Journals ──
          _SectionHeader(
            title: 'Leading Journals',
            subtitle: 'Most frequently appearing sources',
            icon: Icons.menu_book_rounded,
          ),
          const SizedBox(height: 12),
          _buildRankingList(
            context: context,
            entries: provider.topJournals
                .where((e) => e.key != 'Unknown Source')
                .take(5)
                .toList(),
            emptyMessage: 'Not enough journal data.',
            color: colorScheme.primary,
          ),
          const SizedBox(height: 22),

          // ── Top Authors ──
          _SectionHeader(
            title: 'Prolific Authors',
            subtitle: 'Most published researchers in this topic',
            icon: Icons.groups_rounded,
          ),
          const SizedBox(height: 12),
          _buildRankingList(
            context: context,
            entries: provider.topAuthors
                .where((e) => e.key != 'Unknown Author')
                .take(5)
                .toList(),
            emptyMessage: 'Not enough author data.',
            color: colorScheme.secondary,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, AnalyzerProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trends = provider.yearlyTrends;
    final spots = <FlSpot>[];

    int minYear = 9999;
    int maxYear = 0;
    double maxCount = 0;

    trends.forEach((year, count) {
      if (year < minYear) minYear = year;
      if (year > maxYear) maxYear = year;
      if (count > maxCount) maxCount = count.toDouble();
      spots.add(FlSpot(year.toDouble(), count.toDouble()));
    });

    if (spots.isEmpty) {
      minYear = DateTime.now().year - 5;
      maxYear = DateTime.now().year;
      maxCount = 10;
    } else if (minYear == maxYear) {
      minYear = minYear - 2;
      maxYear = maxYear + 2;
    }

    double xInterval = ((maxYear - minYear) / 4).ceilToDouble();
    if (xInterval < 1.0) xInterval = 1.0;
    final double yInterval = (maxCount / 4).clamp(1.0, 100.0);

    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, left: 6, top: 16, bottom: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline.withOpacity(isDark ? 0.3 : 0.15)),
      ),
      child: LineChart(
        LineChartData(
          minX: minYear.toDouble(),
          maxX: maxYear.toDouble(),
          minY: 0,
          maxY: maxCount * 1.2,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => colorScheme.surfaceContainerHighest,
              tooltipBorderRadius: BorderRadius.circular(10),
              tooltipBorder: BorderSide(
                color: colorScheme.primary.withOpacity(0.3), width: 1,
              ),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    '${touchedSpot.x.toInt()}\n${touchedSpot.y.toInt()} papers',
                    TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 12, fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outline.withOpacity(0.1),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  final year = value.toInt();
                  if (year < minYear || year > maxYear) return const SizedBox();
                  return Text(
                    year.toString(),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: spots.length <= 15,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3.5,
                  color: Colors.white,
                  strokeColor: colorScheme.primary,
                  strokeWidth: 2.5,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.18),
                    colorScheme.primary.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList({
    required BuildContext context,
    required List<MapEntry<String, int>> entries,
    required String emptyMessage,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.18)),
        ),
        child: Text(
          emptyMessage,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
        ),
      );
    }

    final maxVal = entries.first.value;

    return Column(
      children: entries.asMap().entries.map((indexed) {
        final index = indexed.key;
        final entry = indexed.value;
        final progress = maxVal > 0 ? entry.value / maxVal : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(isDark ? 0.25 : 0.12),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? color.withOpacity(0.12)
                            : colorScheme.surfaceContainerHighest.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w800,
                            color: index == 0 ? color : colorScheme.onSurfaceVariant.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w800, color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Quick Stats Row ───
class _QuickStatsRow extends StatelessWidget {
  final AnalyzerProvider provider;

  const _QuickStatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final years = provider.yearlyTrends.keys.toList();
    final yearRange = years.isEmpty
        ? 'N/A'
        : years.length == 1
            ? years.first.toString()
            : '${years.first}–${years.last}';

    return Row(
      children: [
        Expanded(
          child: _QuickStatCard(
            label: 'Records',
            value: provider.allWorks.length.toString(),
            color: colorScheme.primary,
            icon: Icons.layers_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickStatCard(
            label: 'Period',
            value: yearRange,
            color: colorScheme.tertiary,
            icon: Icons.date_range_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickStatCard(
            label: 'Journals',
            value: provider.topJournals.length.toString(),
            color: colorScheme.secondary,
            icon: Icons.library_books_outlined,
          ),
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _QuickStatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 84,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline.withOpacity(isDark ? 0.3 : 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16, fontWeight: FontWeight.w800, height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11, fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12, color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
