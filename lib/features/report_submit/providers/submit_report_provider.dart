import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/location_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../models/rain_report.dart';
import '../../home_map/providers/rain_reports_provider.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(supabaseClientProvider));
});

class SubmitReportState {
  const SubmitReportState({this.isSubmitting = false, this.errorMessage});

  final bool isSubmitting;
  final String? errorMessage;

  SubmitReportState copyWith({bool? isSubmitting, String? errorMessage}) {
    return SubmitReportState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class SubmitReportNotifier extends StateNotifier<SubmitReportState> {
  SubmitReportNotifier(this._ref) : super(const SubmitReportState());

  final Ref _ref;

  Future<bool> submit(File photo) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final position =
          await _ref.read(locationServiceProvider).getApproximateLocation();
      final photoUrl =
          await _ref.read(storageServiceProvider).uploadRainPhoto(photo);

      final report = RainReport(
        id: '',
        latitude: position.latitude,
        longitude: position.longitude,
        photoUrl: photoUrl,
        reportedAt: DateTime.now(),
      );

      await _ref.read(rainReportsServiceProvider).submitReport(report);

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }
}

final submitReportProvider =
    StateNotifierProvider<SubmitReportNotifier, SubmitReportState>((ref) {
  return SubmitReportNotifier(ref);
});
