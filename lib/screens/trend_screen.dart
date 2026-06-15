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
        title: const Text('Analytics'),
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
            Icon(Icons.bar_chart_rounded,
                color: colorScheme.primary.withOpacity(0.3), size: 56),
            const SizedBox(height: 16),
            Text(
              'No analytics yet',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Search for a topic to see trends and charts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onNavigateToSearch,
              child: const Text('Start exploring'),
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
                color: colorScheme.secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.secondary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Loading more data (${provider.allWorks.length} / ${provider.totalCount})...',
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
          _KpiRow(provider: provider),
          const SizedBox(height: 28),
          Text(
            'Publications over time',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Annual volume of matching records',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 14),
          _buildChart(context, provider),
          const SizedBox(height: 28),

          Text(
            'Top journals',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Publication count by source',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 14),
          _buildRankingCard(
            context: context,
            entries: provider.topJournals
                .where((e) => e.key != 'Unknown Source')
                .take(5)
                .toList(),
            emptyMessage: 'Not enough journal data.',
            barColor: colorScheme.secondary,
          ),
          const SizedBox(height: 28),

          Text(
            'Featured authors',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Most frequent contributors',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 14),
          _buildRankingCard(
            context: context,
            entries: provider.topAuthors
                .where((e) => e.key != 'Unknown Author')
                .take(5)
                .toList(),
            emptyMessage: 'Not enough author data.',
            barColor: colorScheme.primary,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, AnalyzerProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    '${touchedSpot.x.toInt()}: ${touchedSpot.y.toInt()} papers',
                    TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
              color: colorScheme.outline.withOpacity(0.10),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.4),
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
                      color: colorScheme.onSurface.withOpacity(0.4),
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
              barWidth: 2.5,
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
                    colorScheme.primary.withOpacity(0.15),
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

  Widget _buildRankingCard({
    required BuildContext context,
    required List<MapEntry<String, int>> entries,
    required String emptyMessage,
    required Color barColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          emptyMessage,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
            fontSize: 13,
          ),
        ),
      );
    }

    final maxVal = entries.first.value;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: 13,
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
                    backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor.withOpacity(0.6)),
                    minHeight: 4,
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

class _KpiRow extends StatelessWidget {
  final AnalyzerProvider provider;

  const _KpiRow({required this.provider});

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
          child: _KpiCard(
            label: 'Records',
            value: provider.allWorks.length.toString(),
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _KpiCard(
            label: 'Year span',
            value: yearRange,
            color: colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _KpiCard(
            label: 'Sources',
            value: provider.topJournals.length.toString(),
            color: colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 18,
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
              color: colorScheme.onSurface.withOpacity(0.45),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
