import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home_map/presentation/map_screen.dart';

class RainshareApp extends StatelessWidget {
  const RainshareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rainshare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MapScreen(),
    );
  }
}
