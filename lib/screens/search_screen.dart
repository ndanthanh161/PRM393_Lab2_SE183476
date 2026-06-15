import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/analyzer_provider.dart';
import '../widgets/metric_tag.dart';
import '../widgets/theme_toggle_button.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<_TopicItem> _suggestions = [
    _TopicItem('Artificial Intelligence', Icons.smart_toy_outlined),
    _TopicItem('Software Engineering', Icons.code_rounded),
    _TopicItem('Data Science', Icons.bar_chart_rounded),
    _TopicItem('Cybersecurity', Icons.shield_outlined),
    _TopicItem('Internet of Things', Icons.devices_other_rounded),
    _TopicItem('Blockchain', Icons.link_rounded),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch(String query) {
    if (query.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<AnalyzerProvider>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 17),
            ),
            const SizedBox(width: 10),
            const Text('ScholarFinder'),
          ],
        ),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchHeader(
            controller: _searchController,
            onSearch: _triggerSearch,
            onChanged: () => setState(() {}),
            suggestions: _suggestions,
            provider: provider,
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(AnalyzerProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;

    if (provider.isLoading) {
      return _buildSkeletonList();
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.error.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.wifi_off_rounded, color: colorScheme.error, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  'Connection Error',
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () => _triggerSearch(provider.currentQuery),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (provider.works.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.15),
                        colorScheme.secondary.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      provider.currentQuery.isEmpty
                          ? Icons.auto_stories_rounded
                          : Icons.search_off_rounded,
                      color: colorScheme.primary,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  provider.currentQuery.isEmpty ? 'Start Discovering' : 'Nothing Found',
                  style: TextStyle(
                    fontSize: 19, fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.currentQuery.isEmpty
                      ? 'Type a research topic or pick a suggestion above to explore academic publications.'
                      : 'No results matched "${provider.currentQuery}". Try a different keyword.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.55),
                    fontSize: 13, height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.isBackgroundLoading)
          LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.works.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final work = provider.works[index];
              return _ResultCard(work: work);
            },
          ),
        ),
        if (provider.totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outline.withOpacity(0.2), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PageButton(
                  label: 'Prev',
                  icon: Icons.arrow_back_rounded,
                  onPressed: provider.currentPage > 1
                      ? () => provider.previousPage()
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                  ),
                  child: Text(
                    '${provider.currentPage} / ${provider.totalPages}',
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                _PageButton(
                  label: 'Next',
                  icon: Icons.arrow_forward_rounded,
                  trailingIcon: true,
                  onPressed: provider.currentPage < provider.totalPages
                      ? () => provider.nextPage()
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SkeletonBlock(width: double.infinity, height: 16),
              const SizedBox(height: 8),
              const _SkeletonBlock(width: 150, height: 12),
              const SizedBox(height: 16),
              Row(
                children: [
                  const _SkeletonBlock(width: 60, height: 18, borderRadius: 6),
                  const SizedBox(width: 8),
                  const _SkeletonBlock(width: 80, height: 18, borderRadius: 6),
                  const Spacer(),
                  const _SkeletonBlock(width: 100, height: 12),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Search Header ───
class _SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;
  final VoidCallback onChanged;
  final List<_TopicItem> suggestions;
  final AnalyzerProvider provider;

  const _SearchHeader({
    required this.controller,
    required this.onSearch,
    required this.onChanged,
    required this.suggestions,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(isDark ? 0.08 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded, size: 22),
                hintText: 'Search research papers, topics...',
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          controller.clear();
                          onChanged();
                        },
                      )
                    : Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          onPressed: () => onSearch(controller.text),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ),
              ),
              onChanged: (val) => onChanged(),
              onSubmitted: onSearch,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = suggestions[index];
                final isSelected = provider.currentQuery == item.label;

                return ActionChip(
                  onPressed: () {
                    controller.text = item.label;
                    onSearch(item.label);
                  },
                  avatar: Icon(
                    isSelected ? Icons.check_circle_rounded : item.icon,
                    size: 16,
                    color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                  ),
                  label: Text(item.label),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                  ),
                  backgroundColor: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  side: BorderSide(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.25),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Result Card ───
class _ResultCard extends StatelessWidget {
  final dynamic work;

  const _ResultCard({required this.work});

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
          color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.2),
          width: 1,
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        work.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface, height: 1.4,
                        ),
                      ),
                      if (work.authors.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          work.authors.take(3).join(', ') +
                              (work.authors.length > 3 ? ' +${work.authors.length - 3}' : ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12, height: 1.4,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          MetricTag(
                            text: work.publicationYear.toString(),
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          MetricTag(
                            text: '${work.citedByCount} cited',
                            color: colorScheme.secondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              work.journalName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Topic Item ───
class _TopicItem {
  final String label;
  final IconData icon;
  const _TopicItem(this.label, this.icon);
}

// ─── Skeleton ───
class _SkeletonBlock extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _SkeletonBlock({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<_SkeletonBlock> createState() => _SkeletonBlockState();
}

class _SkeletonBlockState extends State<_SkeletonBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF332820) : const Color(0xFFF3EDE6);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}

// ─── Page Button ───
class _PageButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool trailingIcon;
  final VoidCallback? onPressed;

  const _PageButton({
    required this.label,
    required this.icon,
    this.trailingIcon = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      Icon(icon, size: 16),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    ];

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: const Size(80, 36),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: trailingIcon ? children.reversed.toList() : children,
      ),
    );
  }
}
