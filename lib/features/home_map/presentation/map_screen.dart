import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../models/rain_report.dart';
import '../../report_submit/presentation/camera_capture_screen.dart';
import '../providers/nearby_reports_provider.dart';
import '../providers/user_location_provider.dart';

const double _radiusMeters = 200 * 1609.34; // 200 miles

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(userLocationProvider);
    final reportsAsync = ref.watch(nearbyReportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Raincheck')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
          );
        },
        icon: const Icon(Icons.camera_alt),
        label: const Text('Report rain'),
      ),
      body: locationAsync.when(
        data: (position) {
          final center = latlong.LatLng(position.latitude, position.longitude);
          return _MapBody(center: center, reportsAsync: reportsAsync);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Could not get your location: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _MapBody extends StatelessWidget {
  const _MapBody({required this.center, required this.reportsAsync});

  final latlong.LatLng center;
  final AsyncValue<List<RainReport>> reportsAsync;

  @override
  Widget build(BuildContext context) {
    final reports = reportsAsync.value ?? const <RainReport>[];

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 7,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.rainshare.raincheck',
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: center,
              radius: _radiusMeters,
              useRadiusInMeter: true,
              color: Colors.blue.withValues(alpha: 0.08),
              borderColor: Colors.blue.withValues(alpha: 0.4),
              borderStrokeWidth: 1.5,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 20,
              height: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
            for (final report in reports)
              Marker(
                point: latlong.LatLng(report.latitude, report.longitude),
                width: 36,
                height: 36,
                child: const _RainMarker(),
              ),
          ],
        ),
      ],
    );
  }
}

class _RainMarker extends StatelessWidget {
  const _RainMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: const Icon(Icons.water_drop, color: Color(0xFF2B6CB0), size: 20),
    );
  }
}
