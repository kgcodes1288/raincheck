import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../models/rain_report.dart';
import 'rain_reports_provider.dart';
import 'user_location_provider.dart';

const double _radiusMeters = 200 * 1609.34; // 200 miles

/// Rain reports within 200 miles of the user, keeping only the latest
/// report per approximate location so repeated reports from the same
/// spot don't stack multiple markers.
final nearbyReportsProvider = Provider<AsyncValue<List<RainReport>>>((ref) {
  final reportsAsync = ref.watch(rainReportsStreamProvider);
  final locationAsync = ref.watch(userLocationProvider);

  if (locationAsync.isLoading || reportsAsync.isLoading) {
    return const AsyncValue.loading();
  }
  if (locationAsync.hasError) {
    return AsyncValue.error(
      locationAsync.error!,
      locationAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (reportsAsync.hasError) {
    return AsyncValue.error(
      reportsAsync.error!,
      reportsAsync.stackTrace ?? StackTrace.current,
    );
  }

  final position = locationAsync.value!;
  final reports = reportsAsync.value!;

  final withinRadius = reports.where((report) {
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      report.latitude,
      report.longitude,
    );
    return distance <= _radiusMeters;
  });

  final latestByLocation = <String, RainReport>{};
  for (final report in withinRadius) {
    final key =
        '${report.latitude.toStringAsFixed(2)},${report.longitude.toStringAsFixed(2)}';
    final existing = latestByLocation[key];
    if (existing == null || report.reportedAt.isAfter(existing.reportedAt)) {
      latestByLocation[key] = report;
    }
  }

  return AsyncValue.data(latestByLocation.values.toList());
});
