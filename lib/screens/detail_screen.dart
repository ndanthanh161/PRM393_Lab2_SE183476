import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/work_model.dart';
import '../widgets/metric_tag.dart';
import '../widgets/theme_toggle_button.dart';

class DetailScreen extends StatelessWidget {
  final Work work;

  const DetailScreen({super.key, required this.work});

  Future<void> _openDoi(BuildContext context, String doiUrl) async {
    final Uri url = Uri.parse(doiUrl);
    try {
      final openedExternal = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!openedExternal) {
        final openedInApp = await launchUrl(url);
        if (!openedInApp) {
          throw 'No browser app could open $doiUrl';
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication Record'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(work: work),
            const SizedBox(height: 24),
            if (work.authors.isNotEmpty) ...[
              const _SectionTitle(title: 'Authors'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: work.authors.map((author) {
                  return Chip(
                    label: Text(
                      author,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    side: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            const _SectionTitle(title: 'Abstract'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(
                    alpha: isDark ? 0.35 : 0.18,
                  ),
                ),
              ),
              child: Text(
                work.abstractText,
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurface.withValues(alpha: 0.85),
                  height: 1.7,
                  fontStyle: work.abstractText.startsWith('No abstract')
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (work.doi != null && work.doi!.isNotEmpty) ...[
              const _SectionTitle(title: 'Persistent Identifier'),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colorScheme.outline.withValues(
                      alpha: isDark ? 0.35 : 0.18,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link_rounded,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Digital Object Identifier (DOI)',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              work.doi!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () => _openDoi(context, work.doi!),
                        icon: const Icon(Icons.open_in_new_rounded, size: 14),
                        label: const Text('Open'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Work work;

  const _HeaderCard({required this.work});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  colorScheme.surface,
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                ]
              : [
                  colorScheme.surface,
                  colorScheme.primary.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.12 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MetricTag(
                text: work.publicationYear.toString(),
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              MetricTag(
                text: '${work.citedByCount} citations',
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            work.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.menu_book_outlined,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Source',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      work.journalName,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
