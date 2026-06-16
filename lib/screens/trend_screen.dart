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
        title: const Text('Data Analytics'),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
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
            Icon(
              Icons.insights_rounded,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No Analytics Available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Search for a topic to view publication trends.',
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
                color: colorScheme.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Updating trends (loaded ${provider.allWorks.length} / ${provider.totalCount} papers)...',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          _AnalyticsKpiRow(provider: provider),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Publication Output Over Time',
            subtitle: 'Annual volume of matching research records',
          ),
          const SizedBox(height: 12),
          _buildChart(context, provider),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Annual Publications Count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const _SectionTitle(
            title: 'Top Journals',
            subtitle: 'Publication count by source title',
          ),
          const SizedBox(height: 12),
          _buildRankingCard(
            context: context,
            entries: provider.topJournals
                .where((e) => e.key != 'Unknown Source')
                .take(5)
                .toList(),
            emptyMessage: 'Insufficient journal data.',
            barColor: colorScheme.secondary,
          ),
          const SizedBox(height: 24),

          const _SectionTitle(
            title: 'Featured Authors',
            subtitle: 'Most frequent authors in the loaded dataset',
          ),
          const SizedBox(height: 12),
          _buildRankingCard(
            context: context,
            entries: provider.topAuthors
                .where((e) => e.key != 'Unknown Author')
                .take(5)
                .toList(),
            emptyMessage: 'Insufficient author data.',
            barColor: colorScheme.primary,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.15),
        ),
      ),
      child: LineChart(
        LineChartData(
          minX: minYear.toDouble(),
          maxX: maxYear.toDouble(),
          minY: 0,
          maxY: maxCount * 1.2,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  colorScheme.surfaceContainerHighest,
              tooltipBorderRadius: BorderRadius.circular(8),
              tooltipBorder: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    '${touchedSpot.x.toInt()}: ${touchedSpot.y.toInt()} papers',
                    TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
              color: colorScheme.outline.withValues(alpha: 0.12),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
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
                  if (year < minYear || year > maxYear) {
                    return const SizedBox();
                  }
                  return Text(
                    year.toString(),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
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
              barWidth: 2.8,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: spots.length <= 15,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 3,
                      color: colorScheme.surface,
                      strokeColor: colorScheme.primary,
                      strokeWidth: 2,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.12),
                    colorScheme.primary.withValues(alpha: 0.0),
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

  Widget _buildRankingCard({
    required BuildContext context,
    required List<MapEntry<String, int>> entries,
    required String emptyMessage,
    required Color barColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
          ),
        ),
        child: Text(
          emptyMessage,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
        ),
      );
    }

    final maxVal = entries.first.value;

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
        children: entries.asMap().entries.map((indexed) {
          final index = indexed.key;
          final entry = indexed.value;
          final progress = maxVal > 0 ? entry.value / maxVal : 0.0;
          final isLast = index == entries.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: index == 0
                              ? barColor
                              : colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        entry.key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.value} papers',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: barColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AnalyticsKpiRow extends StatelessWidget {
  final AnalyzerProvider provider;

  const _AnalyticsKpiRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final years = provider.yearlyTrends.keys.toList();
    final yearRange = years.isEmpty
        ? 'N/A'
        : years.length == 1
        ? years.first.toString()
        : '${years.first}-${years.last}';

    return Row(
      children: [
        Expanded(
          child: _AnalyticsKpiCard(
            label: 'Records',
            value: provider.allWorks.length.toString(),
            color: colorScheme.primary,
            icon: Icons.dataset_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AnalyticsKpiCard(
            label: 'Year span',
            value: yearRange,
            color: colorScheme.tertiary,
            icon: Icons.timeline_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AnalyticsKpiCard(
            label: 'Sources',
            value: provider.topJournals.length.toString(),
            color: colorScheme.secondary,
            icon: Icons.menu_book_outlined,
          ),
        ),
      ],
    );
  }
}

class _AnalyticsKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _AnalyticsKpiCard({
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
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
