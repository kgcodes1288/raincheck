import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/rain_reports_service.dart';
import '../../../models/rain_report.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final rainReportsServiceProvider = Provider<RainReportsService>((ref) {
  return RainReportsService(ref.watch(supabaseClientProvider));
});

final rainReportsStreamProvider = StreamProvider<List<RainReport>>((ref) {
  return ref.watch(rainReportsServiceProvider).watchRecentReports();
});
