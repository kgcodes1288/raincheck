import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://raincheck-api.getcleanstays.com',
    publishableKey: 'sb_publishable_QAabg0t6lQJBxwMpmVVD39_CNFgGpZh',
  );
  runApp(const ProviderScope(child: RainshareApp()));
}
