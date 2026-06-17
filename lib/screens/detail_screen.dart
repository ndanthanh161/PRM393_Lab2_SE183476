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
    final hasDoi = work.doi != null && work.doi!.isNotEmpty;

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
            _PaperHeader(
              work: work,
              onOpenDoi: hasDoi ? () => _openDoi(context, work.doi!) : null,
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Abstract'),
            const SizedBox(height: 12),
            _AbstractPanel(abstractText: work.abstractText),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Bibliographic Details'),
            const SizedBox(height: 12),
            _BibliographicDetails(work: work),
          ],
        ),
      ),
    );
  }
}

class _PaperHeader extends StatelessWidget {
  final Work work;
  final VoidCallback? onOpenDoi;

  const _PaperHeader({required this.work, required this.onOpenDoi});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasDoi = work.doi != null && work.doi!.isNotEmpty;
    final authorsText = work.authors.isEmpty
        ? 'Authors not listed'
        : work.authors.join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.12 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDoi) ...[
            _DoiBanner(doi: work.doi!, onOpen: onOpenDoi),
            const SizedBox(height: 18),
          ],
          Text(
            'Research Article',
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            work.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.groups_2_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  authorsText,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.78),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(color: colorScheme.outline.withValues(alpha: 0.18)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InlineMetadata(
                  icon: Icons.menu_book_outlined,
                  label: 'Source',
                  value: work.journalName,
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  MetricTag(
                    text: work.publicationYear > 0
                        ? work.publicationYear.toString()
                        : 'No year',
                    color: colorScheme.secondary,
                  ),
                  MetricTag(
                    text: '${work.citedByCount} citations',
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoiBanner extends StatelessWidget {
  final String doi;
  final VoidCallback? onOpen;

  const _DoiBanner({required this.doi, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.link_rounded, color: colorScheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              doi,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Open DOI',
            onPressed: onOpen,
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            style: IconButton.styleFrom(
              visualDensity: VisualDensity.compact,
              minimumSize: const Size(32, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

class _AbstractPanel extends StatelessWidget {
  final String abstractText;

  const _AbstractPanel({required this.abstractText});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
        ),
      ),
      child: Text(
        abstractText,
        style: TextStyle(
          fontSize: 15,
          color: colorScheme.onSurface.withValues(alpha: 0.85),
          height: 1.7,
          fontStyle: abstractText.startsWith('No abstract')
              ? FontStyle.italic
              : FontStyle.normal,
        ),
      ),
    );
  }
}

class _BibliographicDetails extends StatelessWidget {
  final Work work;

  const _BibliographicDetails({required this.work});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.18),
        ),
      ),
      child: Column(
        children: [
          _MetadataRow(
            label: 'Publication year',
            value: work.publicationYear > 0
                ? work.publicationYear.toString()
                : 'Not available',
          ),
          const Divider(height: 24),
          _MetadataRow(label: 'Source title', value: work.journalName),
          const Divider(height: 24),
          _MetadataRow(label: 'Citation count', value: '${work.citedByCount}'),
          if (work.doi != null && work.doi!.isNotEmpty) ...[
            const Divider(height: 24),
            _MetadataRow(label: 'DOI', value: work.doi!),
          ],
        ],
      ),
    );
  }
}

class _InlineMetadata extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InlineMetadata({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.onSurfaceVariant, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetadataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 128,
          child: Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
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
