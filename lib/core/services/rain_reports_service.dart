import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/rain_report.dart';

class RainReportsService {
  RainReportsService(this._client);

  final SupabaseClient _client;

  /// Only reports from the last 24 hours are considered "current" rain.
  Stream<List<RainReport>> watchRecentReports() {
    return _client
        .from('rain_reports')
        .stream(primaryKey: ['id'])
        .order('reported_at', ascending: false)
        .limit(100)
        .map((rows) {
          final cutoff = DateTime.now().subtract(const Duration(hours: 24));
          return rows
              .map(RainReport.fromMap)
              .where((report) => report.reportedAt.isAfter(cutoff))
              .toList();
        });
  }

  Future<void> submitReport(RainReport report) async {
    await _client.from('rain_reports').insert(report.toMap());
  }
}
