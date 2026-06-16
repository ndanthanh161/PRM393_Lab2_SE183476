import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: IconButton(
        key: ValueKey<bool>(themeProvider.isDark),
        icon: Icon(
          themeProvider.isDark
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
        ),
        tooltip: themeProvider.isDark
            ? 'Switch to light theme'
            : 'Switch to dark theme',
        onPressed: themeProvider.toggle,
      ),
    );
  }
}
