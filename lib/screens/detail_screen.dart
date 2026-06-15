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
        title: const Text('Paper Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          colorScheme.primary.withOpacity(0.12),
                          colorScheme.surface,
                        ]
                      : [
                          colorScheme.primary.withOpacity(0.06),
                          colorScheme.surface,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(isDark ? 0.3 : 0.15),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      MetricTag(
                        text: '📅 ${work.publicationYear}',
                        color: colorScheme.primary,
                      ),
                      MetricTag(
                        text: '📝 ${work.citedByCount} citations',
                        color: colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    work.title,
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface, height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Divider(color: colorScheme.outline.withOpacity(0.15)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.library_books_rounded,
                          color: colorScheme.primary.withOpacity(0.7), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Published In',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11, fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              work.journalName,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 14, fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── Authors ──
            if (work.authors.isNotEmpty) ...[
              _SectionLabel(title: 'Authors'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: work.authors.map((author) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline_rounded,
                            size: 14, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          author,
                          style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
            ],

            // ── Abstract ──
            _SectionLabel(title: 'Abstract'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(isDark ? 0.3 : 0.15),
                ),
              ),
              child: Text(
                work.abstractText,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.85),
                  height: 1.7,
                  fontStyle: work.abstractText.startsWith('No abstract')
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ── DOI ──
            if (work.doi != null && work.doi!.isNotEmpty) ...[
              _SectionLabel(title: 'External Link'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(isDark ? 0.3 : 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.link_rounded, color: colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DOI',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11, fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            work.doi!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 13, fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: () => _openDoi(context, work.doi!),
                      icon: const Icon(Icons.open_in_new_rounded, size: 14),
                      label: const Text('View'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
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
            fontSize: 13, fontWeight: FontWeight.w700,
            color: colorScheme.onSurface, letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
