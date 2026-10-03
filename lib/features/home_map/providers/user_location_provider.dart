import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/providers/location_providers.dart';

final userLocationProvider = FutureProvider<Position>((ref) {
  return ref.watch(locationServiceProvider).getApproximateLocation();
});
