import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class RainshareApp extends StatelessWidget {
  const RainshareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rainshare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _HomePlaceholder(),
    );
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rainshare')),
      body: const Center(
        child: Text('Milestone 0: project scaffold is working.'),
      ),
    );
  }
}
