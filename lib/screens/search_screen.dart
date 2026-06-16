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
  final List<String> _suggestions = [
    'Artificial Intelligence',
    'Software Engineering',
    'Data Science',
    'Cybersecurity',
    'Internet of Things',
    'Blockchain',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                Icons.science_outlined,
                color: colorScheme.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Research Explorer'),
          ],
        ),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Research Query',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(
                                alpha: isDark ? 0.15 : 0.06,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.manage_search_rounded,
                              size: 20,
                            ),
                            hintText: 'Search topics, methods, or domains...',
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (val) => setState(() {}),
                          onSubmitted: _triggerSearch,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(
                              alpha: isDark ? 0.15 : 0.06,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _triggerSearch(_searchController.text),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          minimumSize: const Size(48, 48),
                        ),
                        child: const Icon(Icons.search_rounded, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      final isSelected = provider.currentQuery == suggestion;

                      return ActionChip(
                        onPressed: () {
                          _searchController.text = suggestion;
                          _triggerSearch(suggestion);
                        },
                        avatar: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: colorScheme.onSecondaryContainer,
                              )
                            : Icon(
                                Icons.search_rounded,
                                size: 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                        label: Text(suggestion),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onSurface,
                        ),
                        backgroundColor: isSelected
                            ? colorScheme.secondaryContainer
                            : colorScheme.surfaceContainerHighest.withValues(
                                alpha: 0.4,
                              ),
                        side: BorderSide(
                          color: isSelected
                              ? colorScheme.secondary
                              : colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(AnalyzerProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.isLoading) {
      return _buildSkeletonList();
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: colorScheme.error,
                  size: 36,
                ),
                const SizedBox(height: 12),
                Text(
                  'Failed to load data',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _triggerSearch(provider.currentQuery),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Retry'),
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
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      provider.currentQuery.isEmpty
                          ? Icons.science_outlined
                          : Icons.search_off_rounded,
                      color: colorScheme.primary,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  provider.currentQuery.isEmpty
                      ? 'Explore Research'
                      : 'No Results Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.currentQuery.isEmpty
                      ? 'Enter a topic to discover publications, journals, citation metrics, and yearly trends.'
                      : 'We couldn\'t find any matching publications for "${provider.currentQuery}". Try using different terms.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                    height: 1.5,
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
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.works.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final work = provider.works[index];
              return Card(
                elevation: 0,
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colorScheme.outline.withValues(
                      alpha: isDark ? 0.35 : 0.2,
                    ),
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
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          work.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                        if (work.authors.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            work.authors.take(3).join(', ') +
                                (work.authors.length > 3
                                    ? ' +${work.authors.length - 3}'
                                    : ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            MetricTag(
                              text: work.publicationYear.toString(),
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            MetricTag(
                              text: '${work.citedByCount} citations',
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                work.journalName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.8,
                              ),
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (provider.totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PageButton(
                  label: 'Prev',
                  icon: Icons.chevron_left_rounded,
                  onPressed: provider.currentPage > 1
                      ? () => provider.previousPage()
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    'Page ${provider.currentPage} of ${provider.totalPages}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                _PageButton(
                  label: 'Next',
                  icon: Icons.chevron_right_rounded,
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
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.2),
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
                  const _SkeletonBlock(width: 60, height: 18, borderRadius: 4),
                  const SizedBox(width: 8),
                  const _SkeletonBlock(width: 80, height: 18, borderRadius: 4),
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
    final baseColor = isDark
        ? const Color(0xFF1E2D42)
        : const Color(0xFFE2E8F0);

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
      Icon(icon, size: 18),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
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
